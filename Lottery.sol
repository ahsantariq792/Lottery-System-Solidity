// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public participants;

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 1 ether); //check that the sent amount is equal to one ether
        participants.push(payable(msg.sender)); //inserting the address of the participants into array
    }

    function getBalance() public view returns (uint256) {
        require(msg.sender == manager); // check that the person is manager so he can check the amount
        return address(this).balance;
    }

    function random() public view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        participants.length
                    )
                )
            );
    }

    function selectWinner() public returns (address) {
        require(msg.sender == manager);
        require(participants.length >= 3);
        uint256 r = random(); //generating random number
        address payable winner; //declaring payable variable
        uint256 index = r % participants.length; // dividing random number with the number of participants
        winner = participants[index]; // selecting participants
        winner.transfer(getBalance());
        participants = new address payable[](0); //deleting elements of array
        return winner; 




    }
}
