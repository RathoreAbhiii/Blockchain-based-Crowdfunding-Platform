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
    }

    mapping(uint256 => Campaign) public campaigns;

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
}