
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SalatToken{
    string public constant name = "SalatTokken";
    string public constant symbol = "SLT";
    uint8 public constant decimals = 18;

    uint256 _totalSupply;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address spender, uint256 tokens);
    event Burn(address indexed burner, uint256 tokens);

    constructor(uint256 total){
        _totalSupply = total;
        balances[msg.sender] = _totalSupply;
    }
    function totalSupply()external view returns(uint256){
        return _totalSupply;
    }
    function balanceOf(address _tokenOwner) external view returns(uint256){
        return balances[_tokenOwner];
    }
    function transfer(address _recipient, uint256 _numTokens) external returns(bool) {
        require(_numTokens <= balances[msg.sender], "Insufficient balance in the account");

        uint256 fee = (_numTokens * 10) / 100;
        uint256 senderAmount = _numTokens - fee;

        balances[msg.sender] -= _numTokens;
        balances[_recipient] += senderAmount;

        emit Transfer(msg.sender, _recipient, senderAmount);
        _burn(msg.sender, fee);

        return true;
    }
   
    function approve(address _sender, address _recipient, uint256 _numTokens) external returns(bool){
        allowed[msg.sender][_recipient] = _numTokens;
        emit Approval(msg.sender, _recipient, _numTokens);
        return true;
    }
    function allowance(address _spender, address _tokenOwner, uint256 _numTokens) external view returns(uint256){
        return allowed[_tokenOwner][_spender];
    }

    }
    function transferFrom(address _sender, address _recipient, uint256 _amount) external view returns (uint256) {
        require(_numTokens <= balances[owner], "Insufficient balance");
        require(_numTokens <= allowed[owner][msg.sender], "Insufficient allowance");

        balances[owner] -= _numTokens;
        allowed[owner][msg.sender] -= _numTokens;
        balances[buyer] += _numTokens;
        emit Transfer(owner, buyer, _numTokens);

        return true;
}

