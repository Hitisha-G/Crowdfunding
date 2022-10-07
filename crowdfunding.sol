pragma solidity 0.8.0;

contract crowdfunding
{
    uint target;
    uint public deadline;
    uint public collected=0;
    uint minAmount=100;
    address public manager;
    uint public noOfContributors;
    
    mapping(address=>uint) public contributor;

    constructor(uint _target,uint _deadline){
        manager= msg.sender;
        target=_target;
        deadline=block.timestamp+_deadline;
    }

   // modifier MinContribution
    //{
      //  require(>=minAmount);
        //_;
    //}
    
    uint startTime;

    // function Contribute(uint amount) public {
    //     require(amount>=minAmount,"amount is less than minimum amount");
    //     contributor[msg.sender]=amount;
    //     collected+=amount;
    //     startTime=now;
    // }
    
    
    struct request
    {
        string description;
        address payable recepient;
        uint value;
        bool HaveCollected;
        uint noOfVoters;
        mapping(address=>bool)  voted;
    }
    
    mapping(uint=>request)public requests;
    uint public numRequests;


    function Contributee() public payable
    {
        require(msg.value>=minAmount,"amount is less than minimum amount");
        require(block.timestamp< deadline, "time is over");
        if(contributor[msg.sender]==0)
            noOfContributors++;
        contributor[msg.sender]+=msg.value;
        collected+=msg.value;
    }

    function refund() public 
    {
        require(collected<target,"target reached");
        require(block.timestamp>deadline,"deadline not reached");
        address payable user= payable(msg.sender);
        user.transfer(contributor[msg.sender]);
        collected-=contributor[msg.sender];
        contributor[msg.sender]=0;
        
    }
    modifier OnlyManager{
        require(msg.sender==manager);
        _;
    }

    function PayRequest(string memory _description,address payable _reciepnt,uint _value) public OnlyManager
    {
        request storage newRequest= requests[numRequests];
        numRequests++;
        newRequest.description=_description;
        newRequest.recepient=_reciepnt;
        newRequest.value=_value;
        newRequest.noOfVoters=0;
        if(_value<collected)
            newRequest.HaveCollected=true;
    }


}
