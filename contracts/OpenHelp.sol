// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract OpenHelp{

    struct UserData {
        address id;
        uint donationAmount;
        uint nftID;
        Category category;
    }

    address payable owner;
    uint public totalAmount;

    /*mapping(address => uint) userDonationAmount;
    mapping(address => uint) userNftID;
    mapping(address => uint8) userCategory;*/

    mapping(address => UserData) public userList;
    uint[] private userAmountsLevelLimits;
    enum Category { Nivel0, Nivel1, Nivel2, Nivel3, Nivel4, Nivel5}

    constructor(){
        // contract owner address
        owner =  payable(msg.sender);
        userAmountsLevelLimits = [0,10,20,30,40];
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
        if(_isNewUser){
            //Mint new NFT to _sender with category _userCategory
            // userNftID[_sender] = ...
            //payable(owner).transfer(msg.value);
            totalAmount += msg.value;
            userList[_sender].id = _sender;
            userList[_sender].donationAmount += msg.value;
            userList[_sender].nftID = 123;
            userList[_sender].category = _userNextCategory;
        }else{
            //We need to validate if user user category have changed
            if (_actualUserCategory != _userNextCategory){
                //update NFT metadata with _userNftID
                userList[_sender].category = _userNextCategory;
            }
            //payable(owner).transfer(msg.value);
            totalAmount += msg.value;
            userList[_sender].donationAmount += msg.value;
        }

    }

    function _validateUser(address _user) public view returns (bool _isNew, uint _nftID, Category _actualUserCategory){
        if(userList[_user].nftID != 0){
            _isNew = false;
            _nftID = userList[_user].nftID;
            _actualUserCategory = userList[_user].category;
        }else{
            _isNew = true;
            _nftID = 0;
            _actualUserCategory = Category.Nivel0;
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