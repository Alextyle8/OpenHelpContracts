// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


/// @custom:security-contact hola@brusmax.com
contract OpenHelpNFT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    uint256 thisTokenId;
    uint level = 0;
    string[5] uriData = [
        "https://gateway.pinata.cloud/ipfs/QmWbbQXyhTj6ZYQvbG4MnD9jurao2BZoucQdqW21mPhqcC/open_help_level_1.json",
        "https://gateway.pinata.cloud/ipfs/QmWbbQXyhTj6ZYQvbG4MnD9jurao2BZoucQdqW21mPhqcC/open_help_level_2.json",
        "https://gateway.pinata.cloud/ipfs/QmWbbQXyhTj6ZYQvbG4MnD9jurao2BZoucQdqW21mPhqcC/open_help_level_3.json",
        "https://gateway.pinata.cloud/ipfs/QmWbbQXyhTj6ZYQvbG4MnD9jurao2BZoucQdqW21mPhqcC/open_help_level_4.json",
        "https://gateway.pinata.cloud/ipfs/QmWbbQXyhTj6ZYQvbG4MnD9jurao2BZoucQdqW21mPhqcC/open_help_level_5.json"
    ];
    string[5] previewNFT = [
        "https://gateway.pinata.cloud/ipfs/QmdsesktNhNdwFs1G8Brf97Ea9fVKfgCVzDkUReArH9UXV/nft_oh_level_1.jpg",
        "https://gateway.pinata.cloud/ipfs/QmdsesktNhNdwFs1G8Brf97Ea9fVKfgCVzDkUReArH9UXV/nft_oh_level_2.jpg",
        "https://gateway.pinata.cloud/ipfs/QmdsesktNhNdwFs1G8Brf97Ea9fVKfgCVzDkUReArH9UXV/nft_oh_level_3.jpg",
        "https://gateway.pinata.cloud/ipfs/QmdsesktNhNdwFs1G8Brf97Ea9fVKfgCVzDkUReArH9UXV/nft_oh_level_4.jpg",
        "https://gateway.pinata.cloud/ipfs/QmdsesktNhNdwFs1G8Brf97Ea9fVKfgCVzDkUReArH9UXV/nft_oh_level_5.jpg"

    ];

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("OpenHelp", "OHT") {}

    // We have only 5 levels [0..4]
    modifier validLevel {
      require(level >= 0 || level <= 4, "A valid level is required");
      _;
    }


    function safeMint(address to, uint _level) public validLevel returns(uint256) {
        thisTokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, thisTokenId);
        _setTokenURI(thisTokenId, uriData[_level]);
        return thisTokenId;
    }

    function getTokenId() public view returns(uint256){
        return thisTokenId;
    }


    // Call this function to update the level - NFT
    function changeLevel(uint _tokenId, uint _level) public onlyOwner validLevel {
        _setTokenURI(_tokenId, uriData[_level]);
    }

    // Return an array with the nft image link
    function getPreviewNFT() public view returns(string[5] memory){
        return previewNFT;
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