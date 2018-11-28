pragma solidity ^0.4.17;

contract ShareD {

    uint public numberOfAuthors; // access variable does not change state -> does not cost gas
    mapping(uint => Author) public allAuthorList;  // frontend: get authors then get articles
    // (trick) need nexted mapping, because we cannot access mapping from struct  
    mapping(uint => mapping(uint => Article)) public articleList;  // authorId : (articleId: article)

    struct Article {
        uint articleId;
        uint publishTime;
        string title;
        string briefIntro;
        string mdContentHash; 
        uint donationReceived;
        uint authorId;
    }

    struct Author {
        uint authorId;
        address authorAddress; 
        string authorName;  
        string email;  
        uint numberOfArticles;
    }    

    constructor() public {
        numberOfAuthors = 0;
    }   

    // This function changes state, costs gas, and gas grows
    function registerAsAuthor(string _authorName, string _email) public {
        // TODO: safety filter limit length ... (no dupliacte names)
        // Not sure whether this mapping is initialized
        Author memory author = Author(numberOfAuthors, msg.sender, _authorName, _email, 0);
        allAuthorList[numberOfAuthors] = author;
        numberOfAuthors += 1;
    } 
 
    // This function changes state, costs gas, and gas grows
    // TODO: Use block time
    function publishArticle(uint _publishTime, string _title, string _briefIntro, string _mdContentHash, uint _authorId) public {
        // TODO: safety filter limit length ...
        // TODO: check if you are the registered author
        Author storage author = allAuthorList[_authorId];
        Article memory article = Article(author.numberOfArticles, _publishTime, _title, _briefIntro, _mdContentHash, 0, _authorId);  
        articleList[_authorId][author.numberOfArticles] = article;
        author.numberOfArticles += 1;
        allAuthorList[_authorId] = author;
    }

    // "authorId" and "articleId" should be hidden fields in the frontend
    function donate(uint _authorId, uint _articleId) public payable {
        // TODO: safety filter limit length ...
        // TODO: You cannot donate to yourself
        Author storage author = allAuthorList[_authorId];
        // Transfer money to author
        author.authorAddress.transfer(msg.value);
        // Add donation to article
        Article memory article = articleList[_authorId][_articleId];
        // msg.value is the number of wei (ether / 1e18)
        article.donationReceived += msg.value;
        articleList[_authorId][_articleId] = article;
        allAuthorList[_authorId] = author;
    }
}
