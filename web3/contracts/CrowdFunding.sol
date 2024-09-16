// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign{
        address owner;
        string title;
        string desc;
        uint256 target; // target amount to achieve
        uint256 deadline;
        uint256 amountCollected;
        string image; // image url
        address[] donators; // array to store address of donators
        uint256[] donations;    // array to store number of donations

        bool isActive;
        uint256 validationCount;
    }

    struct Validator {
        address validator;
        uint256 validatedCampaignsCount;
        uint256 rewardBalance;
    }

    mapping(uint256 => Campaign) public campaigns;
    mapping(address => Validator) public validators;

    mapping(uint256 => address[]) private campaignValidators;
    mapping(uint256 => mapping(address => bool)) private hasValidated;

    uint256 public validationThreshold = 2; 
    uint256 public rewardBaseAmount = 0.0001 ether; 


    modifier isNotOwner(uint256 _id) {
        require(msg.sender != campaigns[_id].owner, "Campaign owner cannot be a validator");
        _;
    }

    event CampaignValidated(uint256 indexed _id, address indexed _owner, string _title);

    event CampaignActive(uint256 indexed campaignId);

    event RewardPaid(address indexed _validator, uint256 _reward);

    uint256 public numberOfCampaigns = 0;

    function createCampaign(address _owner, string memory _title, string memory _desc, uint256 _target, uint256 _deadline, string memory _image) public returns(uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns]; 
        
        // is everything ok?
        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future");
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.desc = _desc;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    function donateToCampaign(uint256 _id) public payable{
        uint256 amount = msg.value; // money sent from the frontend

        Campaign storage campaign = campaigns[_id];
        
        //require(campaign.isActive, "Campaign is not yet active");
        
        campaign.donators.push(msg.sender); // push address of donator to donators[]
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value:amount}("");

        if(sent){
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory){
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory){
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns); // an array of all existing campaigns which is also of type (struct) Campaign
        for(uint i = 0; i < numberOfCampaigns; i++){
            Campaign storage item = campaigns[i];
            allCampaigns[i] = item;
        }
        return allCampaigns;
    }

    // for campaign creators
    function withdrawFunds(uint256 _id) public {
        Campaign storage campaign = campaigns[_id];

        // verify campaign owner
        require(msg.sender == campaign.owner, "You must be the owner to withdraw the funds");

        // check balance
        uint256 balance = campaign.amountCollected;
        require(balance > 0, "No funds available to withdraw");

        // Transfer the funds to the owner
        (bool sent, ) = payable(campaign.owner).call{value: balance}("");
        require(sent, "Failed to send funds");
    }

    function validateCampaign(uint256 _id) public isNotOwner(_id) {
        Campaign storage campaign = campaigns[_id];
        // Ensure that the campaign has not already been activated
        require(!campaign.isActive, "Campaign is already active");
        require(!hasValidated[_id][msg.sender], "Validator has already validated this campaign");

        Validator storage validator = validators[msg.sender];
        uint256 maxReward = (campaign.amountCollected * 10) / 10000; // 0.1% of total amount collected

        uint256 reward = rewardBaseAmount * validator.validatedCampaignsCount;
        reward = (reward > maxReward) ? maxReward : reward;

        // adding validator to the campaign's list of validators
        campaignValidators[_id].push(msg.sender);
        hasValidated[_id][msg.sender] = true;

       validators[msg.sender].validatedCampaignsCount++;

       // update validator's reward balance
        if (validators[msg.sender].rewardBalance + reward <= maxReward) {
            validators[msg.sender].rewardBalance += reward;
        }

        // Campaign validation logic
        campaign.validationCount++;
        if (campaign.validationCount >= validationThreshold) {
            campaign.isActive = true;
            emit CampaignActive(_id);
        }

        emit CampaignValidated(_id, msg.sender, campaign.title);
    }

    // withdraw function for Validators
    function withdrawReward() external {
        Validator storage validator = validators[msg.sender];
        uint256 reward = validator.rewardBalance;

        require(reward > 0, "No rewards available");

        // updating state before transferring to prevent re-entrancy
        validator.rewardBalance = 0;

        (bool sent, ) = msg.sender.call{value: reward}("");
        require(sent, "Failed to send Ether reward");

        emit RewardPaid(msg.sender, reward);
    }

    function getCampaignValidators(uint256 _id) external view returns (address[] memory) {
        return campaignValidators[_id];
    }
}