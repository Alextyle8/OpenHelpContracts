// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


/// @custom:security-contact hola@brusmax.com
contract OpenHelpNFT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    uint level = 0;
    string[5] uriData = [
        "https://gateway.pinata.cloud/ipfs/QmQDJgPcbAHXWey8bbTZN3rZzruZ6STqZdCG6MC87wD7CQ",
        "https://gateway.pinata.cloud/ipfs/QmeZ7z552NRfPXQw6xJprvDfHNbxtWHTwtJrE8VREXtUAw",
        "https://gateway.pinata.cloud/ipfs/QmXxB6VXnetjgReng3p7hnSAr56RBSFGBRPRBYYNWAAtYA",
        "https://gateway.pinata.cloud/ipfs/QmVMaLLs23mSkopashS5TmKRJGnqn8xdS1wvFjNRngciCd",
        "https://gateway.pinata.cloud/ipfs/Qme7aLW6ufyWTPkB5yBastSvZ8P3b1UfwNBn7P1GAbSb1d"
    ];

    Counters.Counter private _tokenIdCounter;

    constructor(uint _level) ERC721("OpenHelp", "OHT") {
        level = _level;
    }


    function safeMint(address to) public onlyOwner {
        require(level >= 0 && level <= 4, "A valid level is required");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uriData[level]);
    }

    // Call this function to update the level - NFT
    function changeLevel(uint _tokenId, uint _level) public onlyOwner{
        _setTokenURI(_tokenId, uriData[_level]);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}