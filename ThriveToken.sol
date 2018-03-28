pragma solidity ^0.4.21;

import "./StandardToken.sol";

contract ThriveToken is StandardToken {

    string public constant name = "ThriveToken";
    string public constant symbol = "THRT";
    uint8 public constant decimals = 18;

    uint256 public constant INITIAL_SUPPLY = 280000000 * (10 ** uint256(decimals));

    function ThriveToken() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
    }
}
