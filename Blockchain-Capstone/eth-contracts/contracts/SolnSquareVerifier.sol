pragma solidity >=0.4.21 <0.6.0;

import "./ERC721Mintable.sol";

// define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
contract Verifier {
    function verifyTx(
        uint256[2] memory a,
        uint256[2] memory a_p,
        uint256[2][2] memory b,
        uint256[2] memory b_p,
        uint256[2] memory c,
        uint256[2] memory c_p,
        uint256[2] memory h,
        uint256[2] memory k,
        uint256[2] memory input
    ) public returns (bool r);
}

// define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is ERC721MintableComplete {
    // define a solutions struct that can hold an index & an address
    struct Solution {
        uint256 index;
        address account;
    }

    // define an array of the above struct
    Solution[] private solutions;

    // define a mapping to store unique solutions submitted (solutionHash => solution)
    mapping(bytes32 => bool) private submittedSolutions;

    // Create an event to emit when a solution is added
    event SolutionAdded(uint256 index, address account);

    Verifier verifier;

    constructor(address verifierAddress) public {
        verifier = Verifier(verifierAddress);
    }

    // Create a function to add the solutions to the array and emit the event
    function addSolution(bytes32 solutionHash, address account) private {
        uint256 solutionIndex = solutions.length + 1;
        solutions.push(Solution(solutionIndex, account));
        submittedSolutions[solutionHash] = true;
        emit SolutionAdded(solutionIndex, account);
    }

    function canMintToken(address _to,
        uint[2] memory a,
        uint[2] memory a_p,
        uint[2][2] memory b,
        uint[2] memory b_p,
        uint[2] memory c,
        uint[2] memory c_p,
        uint[2] memory h,
        uint[2] memory k,
        uint[2] memory input)
        public           
    {
        // check if solution is valid
        require(verifier.verifyTx(a, a_p, b, b_p, c, c_p, h, k, input), "solution not valid");
        bytes32 solutionHash = keccak256(abi.encodePacked(a,a_p,b,b_p,c,c_p,h,k,input));
        // require(submittedSolutions[solutionHash], "Solution has been submitted");    
        
        addSolution(solutionHash, _to);        
    }
    // Create a function to mint new NFT only after the solution has been verified
    function mint(
        address to,
        uint256[2] memory a,
        uint256[2] memory a_p,
        uint256[2][2] memory b,
        uint256[2] memory b_p,
        uint256[2] memory c,
        uint256[2] memory c_p,
        uint256[2] memory h,
        uint256[2] memory k,
        uint256[2] memory input
    ) public {
        bytes32 solutionHash = keccak256(
            abi.encodePacked(a, a_p, b, b_p, c, c_p, h, k, input)
        );

        //  - make sure the solution is unique (has not been used before)
        require(
            !submittedSolutions[solutionHash],
            "Solution has been submitted"
        );
        require(
            verifier.verifyTx(a, a_p, b, b_p, c, c_p, h, k, input),
            "Verify failed"
        );

        //  - make sure you handle metadata as well as tokenSuplly
        addSolution(solutionHash, to);
        super.mint(to, solutions.length);
    }
}
