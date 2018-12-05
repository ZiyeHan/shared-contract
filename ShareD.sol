pragma solidity ^0.4.17;

contract ShareD {

    mapping(address => Author) public allAuthorList;  // frontend: get authors then get articles
    // (trick) need nexted mapping, because we cannot access mapping from struct  
    mapping(address => mapping(uint => Article)) public articleList;  // authorAddress : (articleId: article)

    struct Article {
        uint articleId;
        uint publishTime;
        string title;
        string briefIntro;
        string mdContentHash; 
        uint donationReceived;
        address authorAddress;
    }

    struct Author {
        address authorAddress; 
        string authorName;  
        string email;  
        uint numberOfArticles;
    }    

    constructor() public {
    }   

    // This function changes state, costs gas, and gas grows
    function registerAsAuthor(string _authorName, string _email) public {
        bytes memory authorNameBytes = bytes(_authorName); 
        require(
            authorNameBytes.length <= 20,
            "Please use less than 20 bytes for author name."  // currently web3 doesn't support catch error
        );
        bytes memory emailBytes = bytes(_email);  
        require(
            emailBytes.length <= 50,
            "Please use less than 50 bytes for email address."
        );
        require(
            allAuthorList[msg.sender].authorAddress == address(0),
            "Please use a different Ethereum account, this account already exists."
        );
        Author memory author = Author(msg.sender, _authorName, _email, 0);
        allAuthorList[msg.sender] = author;
    } 
 
    // This function changes state, costs gas, and gas grows
    function publishArticle(string _title, string _briefIntro, string _mdContentHash) public {
        bytes memory titleBytes = bytes(_title);  
        require(
            titleBytes.length <= 120,
            "Please use less than 120 bytes for title."
        );
        bytes memory briefBytes = bytes(_briefIntro);  
        require(
            briefBytes.length <= 360,
            "Please use less than 120 bytes for brief intro."
        );
        bytes memory hashBytes = bytes(_mdContentHash);  
        require(
            hashBytes.length == 46,
            "Please use valid ipfs hash address."
        );
        require(
            allAuthorList[msg.sender].authorAddress != address(0),
            "Please register as author first."
        );
        Author storage author = allAuthorList[msg.sender]; // publish as current Metamask user
        Article memory article = Article(author.numberOfArticles, block.timestamp, _title, _briefIntro, _mdContentHash, 0, msg.sender);  
        articleList[msg.sender][author.numberOfArticles] = article;
        author.numberOfArticles += 1;
        allAuthorList[msg.sender] = author;
    }

    // "_authorAddress" and "_articleId" should be hidden fields in the frontend
    function donate(address _authorAddress, uint _articleId) public payable {
        require(
            _authorAddress != msg.sender,
            "You cannot donate to yourself."
        );
        require(
            allAuthorList[_authorAddress].authorAddress != address(0),
            "The account you donate to doesn't exist."
        );
        Author storage author = allAuthorList[_authorAddress]; 
        require(
            author.numberOfArticles > _articleId,
            "The article doesn't exist."
        );
        // Transfer money to author
        _authorAddress.transfer(msg.value);
        // Add donation to article
        Article memory article = articleList[_authorAddress][_articleId];
        // msg.value is the number of wei (ether / 1e18)
        article.donationReceived += msg.value;
        articleList[_authorAddress][_articleId] = article;
    }
}
