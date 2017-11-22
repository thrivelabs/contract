pragma solidity ^0.4.11;

import './IERC20.sol';
import './SafeMath.sol';

contract ThriveToken is IERC20{
    
    using SafeMath for uint256; // for overflow issues;
    
    uint private constant DECIMALS = 1000000000000000000; // Multiplier for the decimals
    uint public _totalSupply=0; // total token supply 
    uint public constant _totalTokens=200000000000000000000000000; // number of mintable tokens (may vary due to bonuses)
    uint public constant _maxTokens=280000000000000000000000000; // max mintable tokens 
    string public constant symbol= "THRTT1";
    string public constant name ="Thrive Token";
    uint8 public constant decimals = 18;
    uint256 public constant RATE = 500; // fixed conversion rate 1 ether =500 THRT
    address public owner; // sets SC owner
    uint256 public presaleStartTime; // pre sale start time
    uint256 public presaleEndTime;  // pre sale end time
    uint256 public round1StartTime; // ICO round 1 start time
    uint256 public round1EndTime; // ICO round 1 end time
    uint256 public round2StartTime; // ICO round 2 start time
    uint256 public round2EndTime; // ICO round 2 end time
    uint256 public _bonus; //sets bonus (if available)
    uint256 public raisedEth = 0; // ether raised after presale
    uint256 public _phase; // current ICO phase
    uint256 public totalRaisedEth = 0;
    uint256 public remaining; // number of tokens left
    uint256 public rem;
    
    
    mapping(address =>uint256) balances;
    
    mapping(address => mapping(address => uint256)) allowed;
    
    function balanceOf(address _owner) constant returns (uint256 balance)
    {
        return balances[_owner];
    }
    
    function() payable
    {
        
        // fallback function (called each time contract receives ETH)
        createTokens();
    }
    
    function ThriveToken() //constructor
    {
        
        uint256 deftokens = 94000000000000000000000000; // sets amount of tokens to assign to owner 
        owner = msg.sender; // sets owner
        balances[owner] = deftokens;
        presaleStartTime = XXXXXXXXXX; // Timestamp of presale start date
        presaleEndTime = presaleStartTime.add(20days);// Timestamp of presale end date
        round1StartTime = XXXXXXXXXX; // Timestamp of ICO round 1 start date
        round1EndTime = round1StartTime.add(20 days);// Timestamp of ICO round 1 end date
        round2StartTime = XXXXXXXXXX; // // Timestamp of ICO round 2 start date
        round2EndTime = round2StartTime.add(20 days);// Timestamp of ICO round 2 end date
        _totalSupply=_totalSupply.add(deftokens);
        // _phase=1;
    }
       
    function finishMinting(uint256 _tokens) public returns (bool) 
    {
        
    // sets all conditions to satisfy to create tokens
        
        remaining=_maxTokens.sub(_totalSupply);
        if(_tokens >= remaining  )
        {
            return true; // NO token creation
            MintFinished();
        }
        else
        {
            return false; // token creation
        }
        
    }
    
    function createTokens() payable  
    {
        
        require(!finishMinting(msg.value.mul(RATE)) );
        
        uint256 tokens;
        uint256 ownerTokens;
        uint256 ownerBonus;
        
        if (now >= presaleStartTime && now <= presaleEndTime  )
        {
            _phase = 1; // we are in pre sale period
        } 
        else if (now >= round1StartTime && now <= round1EndTime  )
        {
            _phase = 2; // we are in crowd sale round 1 period
        } 
        else if (now >= round2StartTime && now <= round2EndTime  )
        {
            _phase = 3; // we are in crowd sale round 2 period
        }
        else if (now >= round2EndTime  )
        {
            _phase = 99; // ICO finished
        }
        else 
        {
            _phase = 0; // we are in no sale period
        }
        
        if ( _phase==0) 
        {
            revert();
        }
        else if(_phase == 1 )
        {
            _bonus = RATE.div(100).mul(140);
            ownerBonus = RATE.div(100).mul(40);
            // on presale minimum required amount =100 ETH
            if ( msg.value >= 10 ether)
            {
                tokens = msg.value.mul(_bonus); // Number of tokens to send 
                ownerTokens = msg.value.mul(ownerBonus).div(53).mul(47); // bonus tokens to send to owner
                balances[msg.sender] = balances[msg.sender].add(tokens); // send tokens
                balances[owner] = balances[owner].add(ownerTokens);  // send tokens to owner
                _totalSupply = _totalSupply.add(tokens).add(ownerTokens); // adds created tokens to total supply
                //_totalTokens= _totalTokens.add(ownerTokens.mul(2)); // adds bonus to total tokens limit
                owner.transfer(msg.value); // transfers ETH to owner
                //raisedEth = raisedEth.add(msg.value); // adds ether to calculate bonus
                totalRaisedEth= totalRaisedEth.add(msg.value); // adds ether to total
            }
            else
            {
                revert();
            }
            
        }  
        else if(_phase == 2 || _phase == 3)
        {
            if(msg.value > 0 )
            {
                if(raisedEth < /*10000*/2 ether)
                { 
                    // 30% bonus
                    _bonus = RATE.div(100).mul(130);
                    ownerBonus = RATE.div(100).mul(30);
                
                }
                else if(raisedEth >= /*10000*/ 2 ether && raisedEth < /*25000*/ 5 ether)
                { 
                    // 25% bonus
                    _bonus = RATE.div(100).mul(125);
                    ownerBonus = RATE.div(100).mul(25);
                }
                else if(raisedEth >= /*25000*/5 ether && raisedEth < /*50000*/8 ether)
                { 
                    // 20% bonus
                    _bonus = RATE.div(100).mul(120);
                    ownerBonus = RATE.div(100).mul(20);
                }
                else if(raisedEth >= /*50000*/8 ether && raisedEth < /*100000*/ 11 ether)
                { 
                    // 15% bonus
                    _bonus = RATE.div(100).mul(115);
                    ownerBonus = RATE.div(100).mul(15);
                }
                else if(raisedEth >= /*100000*/ 11 ether && raisedEth < /*150000*/ 14 ether)
                { 
                    // 10% bonus
                    _bonus = RATE.div(100).mul(110);
                    ownerBonus = RATE.div(100).mul(10);
                }
                else 
                {
                    _bonus = RATE;
                    ownerBonus = 0;
                }
            
                tokens = msg.value.mul(_bonus); // Number of tokens to send 
                ownerTokens = msg.value.mul(ownerBonus).div(53).mul(47); // bonus tokens to send to owner
                balances[msg.sender] = balances[msg.sender].add(tokens); // send tokens
                balances[owner] = balances[owner].add(ownerTokens);  // send tokens to owner
                _totalSupply = _totalSupply.add(tokens).add(ownerTokens); // adds created tokens to total supply
                owner.transfer(msg.value); // transfers ETH to owner
                raisedEth = raisedEth.add(msg.value); // adds ether to calculate bonus
                totalRaisedEth= totalRaisedEth.add(msg.value); // adds ether to total
            }
            else
            {
               revert();
            }
        }
        else if(_phase == 99)
        {
            if (msg.sender == owner)
            {
                if (_totalSupply< _totalTokens)
                {
                    rem = _totalTokens.sub(_totalSupply);
                    balances[owner]=balances[owner].add(rem);
                    _totalSupply = _totalSupply.add(rem);
                    owner.transfer(msg.value); // transfers ETH to owner
                }
                else
                {
                   revert();
                }       
            }
            else
            {
                revert();
            }
        }
    }
    
    function totalSupply() constant returns (uint256 totalSupply)
    {
        return _totalSupply;
    }
    
    function transfer(address _to, uint256 _value) returns (bool success)
    {
        require(
            balances[msg.sender] >= _value
            && _value > 0
        );
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] =balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success)
    {
        require(
            allowed[_from][msg.sender] >= _value
            && balances[_from] >= _value
            && _value >0
        );
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    event MintFinished();
}
