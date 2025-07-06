// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Twitter{

    uint16 public MAX_TWEET_LENGTH = 280;

    struct Tweet{
        uint256 id;
        address author;
        string tweet;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) public tweets;
    
    address public owner;

    event TweetCreated(uint256 id, string conetnt, address author, uint256 timestamp);
    event TweetLiked(address liker, address tweetOwner, uint256 tweetId, uint256 likes);
    event TweetUnLiked(address liker, address tweetOwner, uint256 tweetId, uint256 likes);


    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"You are not the owner!");
        _;
    } 

    function createTweet(string memory _tweet) public {

        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is too long!");

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,       
            author: msg.sender,
            tweet: _tweet,
            timestamp: block.timestamp,
            likes: 0

        });

        tweets[msg.sender].push(newTweet);

        emit TweetCreated(newTweet.id, newTweet.tweet, newTweet.author, newTweet.timestamp);
    }

    function getTweet(address _owner, uint _i) public view returns (Tweet memory){
        return tweets[_owner][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory){
        return tweets[_owner];
    }

    function likeTweet(address author, uint256 id) external {
        require(tweets[author][id].id ==id ,"Unauthorized Tweet!");
        
        tweets[author][id].likes++;

        emit TweetLiked(msg.sender, author, id,tweets[author][id].likes);
    }

        function unLikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id ==id ,"Unauthorized Tweet!");
        require(tweets[author][id].likes > 0 ,"You can't unlike a tweet with zero likes!");

        tweets[author][id].likes--;

        emit TweetUnLiked(msg.sender, author, id,tweets[author][id].likes);

    }

    function changeTweetLength(uint16 newLength) public onlyOwner{
        MAX_TWEET_LENGTH = newLength;
    }
}