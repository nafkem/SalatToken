// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SalatTokenMining {

    uint256 public salatCount = 1;
    string public constant name = "SalatTokenMining";
    string public constant symbol = "SLT";
    uint8 public constant decimals = 18;
    uint256 public totalLockedTokens;

    uint256 private _totalSupply;
    address public owner;
    uint256 public miningThreshold;
    bool public emergencyStop;


    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;
    mapping(address => uint256) public salatCounts;
    mapping(address => uint256) public hashRates;
    mapping(address => uint256) public lockedTokens;


    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
    event Burn(address indexed burner, uint256 tokens);
    event SalatCountUpdated(address indexed user, uint256 newCount);
    event HashRateUpdated(address indexed user, uint256 newRate);
    event ThresholdSet(uint256 newThreshold);
    event TokensWithdrawn(address indexed user, uint256 amount);
    event EmergencyStop(bool stopped);
    event Resumed(bool resumed);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(uint256 total) {
        _totalSupply = total;
        balances[msg.sender] = _totalSupply;
        owner = msg.sender;
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

    function updateSalatCounts(uint256 _newCount) external {
        salatCounts[msg.sender] = _newCount;
        emit SalatCountUpdated(msg.sender, _newCount);
    }

    function updateHashRates(uint256 _newRate) external {
        hashRates[msg.sender] = _newRate;
        emit HashRateUpdated(msg.sender, _newRate);
    }

    function setThreshold(uint256 _newThreshold) external onlyOwner {
        miningThreshold = _newThreshold;
        emit ThresholdSet(_newThreshold);
    }

    function withdrawMinedTokens(uint256 _amount) external {
        require(_amount <= balances[msg.sender], "Insufficient balance");
        require(_amount <= lockedTokens[msg.sender], "Tokens are locked");
        balances[msg.sender] -= _amount;
        totalLockedTokens -= _amount;
        emit TokensWithdrawn(msg.sender, _amount);
    }

    function triggerEmergencyStop() external onlyOwner {
    emergencyStop = true;
    emit EmergencyStop(true);
}

    function resume() external onlyOwner {
        emergencyStop = false;
        emit Resumed(true);
    }
}
