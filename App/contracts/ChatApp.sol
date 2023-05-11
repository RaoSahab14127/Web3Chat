// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
contract ChatApp {
    struct user {
        string name;
        friend[] friendlist;
    }
    struct friend {
        address pubkey;
        string name;
    }
    struct message {
        address sender;
        uint timestamp;
        string msg;
    }
    struct AllUserStruck {
        string name;
        address accountAddress;
    }
    AllUserStruck[] getAllUsers;
    mapping (address => user) userlist;
    mapping (bytes32 => message[]) allMessages;
    function checkUserExists(address pubkey) public view returns (bool) {
        return(bytes(userlist[pubkey].name).length>0);
    }
    function createAccount(string calldata name) external{
        require(checkUserExists(msg.sender)== false, "User already exist");
        require(bytes(name).length>0, "Username cannot be empty");
        userlist[msg.sender].name = name;
        getAllUsers.push(AllUserStruck(name, msg.sender));
    }
    function getUsername(address pubkey)external view returns (string memory) {
        require(checkUserExists(pubkey), "User is not register");
        return(userlist[pubkey].name);        
    }
    function addFriend(address friend_key, string calldata name)  external {
        require(checkUserExists(msg.sender), "User is not register create account first");
        require(checkUserExists(friend_key), "Friend is not register");
        require(msg.sender!= friend_key , "User cannot add themselfeves as friend");
        require(CheckAlreadyFriends(msg.sender,friend_key)==false, "Already Friend");

        _addFriend(msg.sender, friend_key, name);
        _addFriend(friend_key,msg.sender, userlist[msg.sender].name);

        
    }
    function CheckAlreadyFriends(address pubkey1,address pubkey2) internal view returns (bool) {
        if(userlist[pubkey1].friendlist.length>userlist[pubkey2].friendlist.length){
            address tmp = pubkey1;
            pubkey1 = pubkey2;
            pubkey2 = tmp;
        }        
        for (uint i = 0; i < userlist[pubkey1].friendlist.length; i++) {
            if(userlist[pubkey1].friendlist[i].pubkey == pubkey2) return true;

        }
        return false;
    }
    function _addFriend(address me, address friend_key, string memory name) internal{
        friend memory newFriend = friend(friend_key, name);
        userlist[me].friendlist.push(newFriend);
    }
    function getMyFriendList() external view returns (friend[] memory) {
        return userlist[msg.sender].friendlist;        
    }

    function _getChatCode(address pubkey1, address pubkey2) internal pure returns (bytes32) {
        if (pubkey1<pubkey2){
            return keccak256(abi.encodePacked(pubkey1, pubkey2));
        }else {
            return keccak256(abi.encodePacked(pubkey2, pubkey1));
        }
    }
    function sendMessage(address friend_key, string calldata _msg) external{
        require(checkUserExists(msg.sender), "create account first");
        require(checkUserExists(friend_key), "friend is not a user");
        require(CheckAlreadyFriends(msg.sender, friend_key), "you are not friend with given user");

        bytes32 chatCode = _getChatCode(msg.sender, friend_key);
        message memory newMsg  = message(msg.sender, block.timestamp, _msg);
        allMessages[chatCode].push(newMsg);
    }
    function readMessage(address friend_key) external view  returns ( message[] memory) {
        bytes32 chatCode = _getChatCode(msg.sender, friend_key);
        return allMessages[chatCode];

    }
    function getAllAppUser() public view returns (AllUserStruck[] memory) {
        return getAllUsers;        
    }

}