var ERC721MintableComplete = artifacts.require('ERC721MintableComplete');

contract('TestERC721Mintable', (accounts) => {
    
    const account_one = accounts[0];
    const account_two = accounts[1];
    let contract;
    console.log(account_one)
    describe('match erc721 spec', () => {
        beforeEach(async () => { 
            contract = await ERC721MintableComplete.new({from: account_one});
            // TODO: mint multiple tokens
            await contract.mint(account_one, 1, { from: account_one });
            await contract.mint(account_two, 2, { from: account_one });
            await contract.mint(account_two, 3, { from: account_one });
        })

        it('should return total supply', async () => { 

            const supply = await contract.totalSupply();
            assert.equal(supply, 3);
            
        });

        it('should get token balance', async function () { 
            const balanceOfAccountOne = await contract.balanceOf(account_one);
            const balanceOfAccountTwo = await contract.balanceOf(account_two);
            assert.equal(balanceOfAccountOne, 1);
            assert.equal(balanceOfAccountTwo, 2);

        })

        // token uri should be complete i.e: https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/1
        it('should return token uri', async function () { 
            const token1Uri = await contract.tokenURI(1);
            const token2Uri = await contract.tokenURI(2);

            assert.equal(token1Uri, "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/1");
            assert.equal(token2Uri, "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/2");
        })

        it('should transfer token from one owner to another', async function () { 
            const tokenId = 1
            await contract.transferFrom(account_one, account_two, tokenId, {from: account_one});
            const ownerOfToken1 = await contract.ownerOf(tokenId);
            assert.equal(ownerOfToken1, account_two);
        })
    });

    describe('have ownership properties', function () {
        beforeEach(async function () { 
            this.contract = await ERC721MintableComplete.new({from: account_one});
        })

        it('should fail when minting when address is not contract owner', async function () { 
            let isRevert = false;
            try {
                await contract.mint(account_two, 1, { from: account_two });
            } catch (e) {
                isRevert = true;
            }
            assert.equal(isRevert, true)
        })

        it('should return contract owner', async function () { 
            contractOwner = await contract.owner();
            assert.equal(contractOwner, account_one);
        })

    });
})
