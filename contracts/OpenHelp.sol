// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

    interface IOpenHelp{
        function safeMint(address _to, uint _level) external returns (uint);
        //function getTokenId() external returns(uint256);
        function changeLevel(uint _tokenId, uint _level) external;
        function getPreviewNFT() external view returns(string[5] memory);
    }


contract OpenHelp{

    address nftContractAddress;

    struct UserData {
        address id;
        uint donationAmount;
        uint nftID;
        Category category;
    }

    address payable owner;
    uint public totalAmount;
    mapping(address => UserData) public userList;
    uint[] private userAmountsLevelLimits;
    enum Category { Nivel1, Nivel2, Nivel3, Nivel4, Nivel5 }

    constructor(address _nftContractAddress){
        // contract owner address
        owner =  payable(msg.sender);
        userAmountsLevelLimits = [0,10,20,30,40];
        nftContractAddress = _nftContractAddress;
    }

    function setNftContractAddress(address _nftContractAddress) public{
        nftContractAddress = _nftContractAddress;
    }

    function safeMint(address _to, uint _level) private  returns (uint){
        return IOpenHelp(nftContractAddress).safeMint(_to, _level);
    }

    function changeLevel(uint _tokenId, uint _level) private{
        IOpenHelp(nftContractAddress).changeLevel(_tokenId,_level);
    }

    function getPreviewNFT() public view returns(string[5] memory){
        return IOpenHelp(nftContractAddress).getPreviewNFT();
    }

    /**
     * Function when users donate eth crypto to OpenHelp
     * @dev Store value in variable
     * param num value to store
     */
    function _donate() public payable{
        require(msg.value > userAmountsLevelLimits[0], "Value must be greater than the minimun amount.");
        address _sender = msg.sender; // user address
        (bool _isNewUser, uint _userNftID, Category _actualUserCategory) = _validateUser(_sender);
        Category _userNextCategory = _getCategory(_sender, msg.value);

        require(payable(owner).send(msg.value), "Transacction aborted.");
        userList[_sender].donationAmount += msg.value;
        userList[_sender].category = _userNextCategory;
        totalAmount += msg.value;
        if(_isNewUser){
            uint idNft = safeMint(_sender,4);   //********* REVISAR ****************
            userList[_sender].id = _sender;
            userList[_sender].nftID = idNft;
        }else{
            //We need to validate if user user category have changed
            if (_actualUserCategory != _userNextCategory){
                changeLevel(_userNftID,3);    //********* REVISAR ****************
            }
        }

    }

    function _validateUser(address _user) public view returns (bool _isNew, uint _nftID, Category _actualUserCategory){
        if(userList[_user].nftID != 0){
            _isNew = false;
            _nftID = userList[_user].nftID;
            _actualUserCategory = userList[_user].category;
        }else{
            _isNew = true;
        }
    }

    function _getCategory(address _user, uint amount) public view returns (Category _category){
        // SUM curren userList[_user].donationAmount + amount
        uint _nextAmount = userList[_user].donationAmount + amount;
        if(
            _nextAmount >= userAmountsLevelLimits[0] && 
            _nextAmount < userAmountsLevelLimits[1]
        ){
            _category = Category.Nivel1;
        }else if(
            _nextAmount >= userAmountsLevelLimits[1] && 
            _nextAmount < userAmountsLevelLimits[2]
        ){
            _category = Category.Nivel2;
        }else if(
            _nextAmount >= userAmountsLevelLimits[2] && 
            _nextAmount < userAmountsLevelLimits[3]
        ){
            _category = Category.Nivel3;
        }else if(
            _nextAmount >= userAmountsLevelLimits[3] && 
            _nextAmount < userAmountsLevelLimits[4]
        ){
            _category = Category.Nivel4;
        }else{
            _category = Category.Nivel5;
        }
    }
}