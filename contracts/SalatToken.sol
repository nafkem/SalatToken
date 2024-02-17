// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SalatToken {
    string public constant name = "SalatToken";
    string public constant symbol = "SLT";
    uint8 public constant decimals = 18;

    uint256 private _totalSupply;
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
    event Burn(address indexed burner, uint256 tokens);

    constructor(uint256 total) {
        _totalSupply = total;
        balances[msg.sender] = _totalSupply;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _tokenOwner) external view returns (uint256) {
        return balances[_tokenOwner];
    }

    function transfer(address _recipient, uint256 _numTokens) external returns (bool) {
        require(_numTokens <= balances[msg.sender], "Insufficient balance in the account");
        uint256 senderAmount = _numTokens;
        balances[msg.sender] -= _numTokens;
        balances[_recipient] += senderAmount;
        emit Transfer(msg.sender, _recipient, senderAmount);
        return true;
    }

    function approve(address _spender, uint256 _numTokens) external returns (bool) {
        allowed[msg.sender][_spender] = _numTokens;
        emit Approval(msg.sender, _spender, _numTokens);
        return true;
    }

    function allowance(address _tokenOwner, address _spender) external view returns (uint256) {
        return allowed[_tokenOwner][_spender];
    }

    function transferFrom(address _sender, address _recipient, uint256 _numTokens) external returns (bool) {
        require(_numTokens <= IERC20(address(this)).allowance(_sender, msg.sender), "Insufficient allowance");
        require(_numTokens <= balances[_sender], "Insufficient balance in the sender account");

        balances[_sender] -= _numTokens;
        balances[_recipient] += _numTokens;
        IERC20(address(this)).approve(msg.sender, IERC20(address(this)).allowance(_sender, msg.sender) - _numTokens); // Update allowance
        emit Transfer(_sender, _recipient, _numTokens);
        return true;
    }
}
