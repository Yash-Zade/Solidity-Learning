// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Token {

    address private owner;
    uint public totalSupply = 0;
    uint public decimals = 18;
    string public name;
    string public symbol;
    mapping (address => uint ) balances;
    mapping (address => mapping (address => uint)) allowances;



    constructor(string memory _name, string memory _symbol, uint _decimals) {
        owner = msg.sender;
        name = _name;
        symbol =_symbol;
        decimals = _decimals;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);


    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    function mint(uint _value) public onlyOwner{
        balances[owner] += _value;
        totalSupply += _value;
    }

    function mintTo(uint _value, address _to) public onlyOwner{
        balances[_to] += _value;
        totalSupply += _value;
    }

    function transfer(address _to, uint _value) public{
        uint existingBalance = balances[msg.sender];
        require(existingBalance >= _value, "You don't have enough balance");
        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
    }

    function burn(uint _value) public{
        uint existingBalance = balances[msg.sender];
        require(existingBalance >= _value, "You don't have enough balance");
        balances[msg.sender] -= _value;
        totalSupply -= _value;

    }

    function approve(address _spender, uint _value) public returns (bool susscess){
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool success){
        uint allowance = allowances[_from][msg.sender];
        require(allowance >= _value);
        
        uint balance = balances[_from];
        require(balance >= _value);

        balances[_from] -= _value;
        balances[_to] += _value;
        allowances[_from][msg.sender] -= _value;
        
        return true;
    }
}