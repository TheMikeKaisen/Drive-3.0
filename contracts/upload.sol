// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Upload {

    struct Access {
        address user; 
        bool access;
    }
    mapping(address=>string[]) value; // stores url of photos as string

    // verifies if another user can access your photos
    mapping(address=>mapping(address=>bool)) ownership;

    // stores the list of addresses that can access your photos
    mapping(address=>Access[]) accessList;

    // stores previous data on blockchain
    mapping(address=>mapping(address=>bool)) previousData;

    // adding a user
    function add(address _user, string memory url) external {
        value[_user].push(url);
    }

    // allowing a user to access the photos
    function allow(address user) external {
        ownership[msg.sender][user] = true;

        // if the user is already present in the previous data then just update the user access to true, otherwise, 
        //  add the user to the previous data and then update the accessList 
        if(previousData[msg.sender][user]){
            for (uint i = 0; i<accessList[msg.sender].length; i++) 
            {
                if(accessList[msg.sender][i].user == user){
                    accessList[msg.sender][i].access = true;
                }
            }

        }
        else{
            previousData[msg.sender][user] = true;
            accessList[msg.sender].push(Access(user, true));
        }
    }

    function disallow(address user) public {
        ownership[msg.sender][user] = false;

        for (uint i =0; i<accessList[msg.sender].length; i++) 
        {
            if(accessList[msg.sender][i].user == user){
                accessList[msg.sender][i].access = false;
            }
        }
    }

    function display(address _user) external view returns(string[] memory) {
        require(_user == msg.sender || ownership[_user][msg.sender], "You dont have access!");
        return value[_user];
    }

    function shareAccess() public view returns(Access[] memory){
        return accessList[msg.sender];
    }
}