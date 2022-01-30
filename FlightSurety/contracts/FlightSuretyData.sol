pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract FlightSuretyData {
    using SafeMath for uint256;

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    address private contractOwner;                                      // Account used to deploy contract
    bool private operational = true;                                    // Blocks all state changes throughout the contract if false
    
    struct Airline {
        address airlineAddress;
        bool isFunded;
        bool isRegistered;
        address[] voters;
    }
    mapping(address => Airline) private registeredAirlines;

    uint256 registeredAirlineCounter = 0;
    uint256 totalFunds = 0;
    address[] airlineAddrs;

     // Flight status codees
    uint8 private constant STATUS_CODE_UNKNOWN = 0;
    uint8 private constant STATUS_CODE_ON_TIME = 10;
    uint8 private constant STATUS_CODE_LATE_AIRLINE = 20;
    uint8 private constant STATUS_CODE_LATE_WEATHER = 30;
    uint8 private constant STATUS_CODE_LATE_TECHNICAL = 40;
    uint8 private constant STATUS_CODE_LATE_OTHER = 50;

    struct Flight {
        bool isRegistered;
        uint8 statusCode;
        uint256 updatedTimestamp;
        address airline;
        string flight;
        string from;
        string to;
    }
    mapping(bytes32 => Flight) private flights;

     // Insurances
    struct Insurance {
        address passenger;
        uint256 amount; // Passenger insurance payment
        bool isCredited;
    }
    mapping(bytes32 => Insurance[]) insurancesPerFlight;
    mapping(address => uint256) public pendingPayments;


    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/


    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor
                                (
                                ) 
                                public 
    {
        contractOwner = msg.sender;
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "operational" boolean variable to be "true"
    *      This is used on all state changing functions to pause the contract in 
    *      the event there is an issue that needs to be fixed
    */
    modifier requireIsOperational() 
    {
        require(operational, "Contract is currently not operational");
        _;  // All modifiers require an "_" which indicates where the function body will be added
    }

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    /**
    * @dev Get operating status of contract
    *
    * @return A bool that is the current operating status
    */      
    function isOperational() 
                            public 
                            view 
                            returns(bool) 
    {
        return operational;
    }


    /**
    * @dev Sets contract operations on/off
    *
    * When operational mode is disabled, all write transactions except for this one will fail
    */    
    function setOperatingStatus
                            (
                                bool mode
                            ) 
                            external
                            requireContractOwner 
    {
        operational = mode;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

   /**
    * @dev Add an airline to the registration queue
    *      Can only be called from FlightSuretyApp contract
    *
    */   
    function registerAirline(address airlineAddress)
        external
        requireIsOperational
    {
        
        registeredAirlines[airlineAddress] = Airline({
            airlineAddress: airlineAddress,
            isFunded: false,
            isRegistered: true,
            voters: new address[](0)
        });
        airlineAddrs.push(airlineAddress);

        registeredAirlineCounter = registeredAirlineCounter.add(1);
    }

    function isAirlineRegistered(address airlineAddress)
        external
        view
        returns (bool)
    {
        return registeredAirlines[airlineAddress].isRegistered;
    }

    function isAirlineFunded(address airlineAddress)
        external
        view
        returns (bool)
    {
        return registeredAirlines[airlineAddress].isFunded;
    }


    function voteForAirline(address voter, address airlineAddress)
        external
        returns (uint256)
    {
        Airline storage airline = registeredAirlines[airlineAddress];
        if (airline.airlineAddress == address(0)) {
            registeredAirlines[airlineAddress] = Airline({
                airlineAddress: airlineAddress,
                isFunded: false,
                isRegistered: false,
                voters: new address[](0)
            });
            airline = registeredAirlines[airlineAddress];
        }

        address[] memory voters = airline.voters;

        bool isVoted = false;
        for (uint256 i = 0; i < voters.length; i++) {
            address votedAddr = voters[i];
            if (votedAddr == airlineAddress) {
                isVoted = true;
                break;
            }
        }
        require(isVoted == false, "The voter is voted");

        airline.voters.push(voter);
    }

   /**
    * @dev Buy insurance for a flight
    *
    */   
    function buy(address airline, string flight, uint256 timestamp, address passenger, uint256 amount)
        external 
        payable 
    {
        bytes32 flightKey = getFlightKey(airline, flight, timestamp);
        require(flights[flightKey].isRegistered, "Flight is not registered");

        insurancesPerFlight[flightKey].push(
            Insurance({passenger: passenger, amount: amount, isCredited: false})
        );
    }

    /**
     *  @dev Transfers eligible payout funds to insuree
     *
    */
    function pay(address passenger) 
        external
    {
        uint256 amount = pendingPayments[passenger];
        pendingPayments[passenger] = 0;

        passenger.transfer(amount);
    }

   /**
    * @dev Initial funding for the insurance. Unless there are too many delayed flights
    *      resulting in insurance payouts, the contract should be self-sustaining
    *
    */   
    function fund(address airlineAddress, uint256 amount)
        payable
        external
        requireIsOperational
    {
        registeredAirlines[airlineAddress].isFunded = true;
        totalFunds = totalFunds.add(amount); 
    }

    function getOperationalAirlineCount()
        external
        view
        returns (uint256)
    {
        uint256 count = 0;
        for (uint256 i = 0; i < airlineAddrs.length; i++) {
            address airlineAddr = airlineAddrs[i];
            if (registeredAirlines[airlineAddr].isRegistered) {
                count = count.add(1);
            }
        }
        return count;
    }

    function getFlightKey(address airline, string memory flight, uint256 timestamp)
        pure
        internal
        returns(bytes32) 
    {
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }


    function processFlightStatus(address airline, string flight, uint256 timestamp, uint8 statusCode)
        external 
    {
        bytes32 flightKey = getFlightKey(airline, flight, timestamp);
        if (flights[flightKey].statusCode == STATUS_CODE_UNKNOWN) {
            flights[flightKey].statusCode = statusCode;
            if (statusCode == STATUS_CODE_LATE_AIRLINE) {
                creditInsurees(airline, flight, timestamp);
            }
        }
    }

    function creditInsurees(address airline, string flight, uint256 timestamp)
        internal 
    {
        bytes32 flightKey = getFlightKey(airline, flight, timestamp);

        for (uint256 i = 0; i < insurancesPerFlight[flightKey].length; i++) {
            Insurance memory insurance = insurancesPerFlight[flightKey][i];

            if (!insurance.isCredited) {
                insurance.isCredited = true;
                uint256 amount = insurance.amount.mul(15).div(10);
                pendingPayments[insurance.passenger] += amount;
            }
        }
    }

    function getCreditedAmount(address passenger)
        external
        view
        returns (uint256)
    {
        return pendingPayments[passenger];
    }


    // /**
    // * @dev Fallback function for funding smart contract.
    // *
    // */
    // function() 
    //                         external 
    //                         payable 
    // {
    //     fund();
    // }


}

