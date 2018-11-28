import "../styles/app.css";

import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

import ShareDArtifacts from '../../build/contracts/ShareD.json' 

var ShareD = contract(ShareDArtifacts);

window.App = {
 start: function() {
  ShareD.setProvider(web3.currentProvider);
  // Tests
  // registerAuthor('Chris', 'chris@ucsc.edu');
  // listAllArticles();
  // isRegistered();
  // showArticleDetail(1, 1);
 }
};

function registerAuthor(authorName, authorEmail) {
  ShareD.deployed().then(function(contractInstance) { 
    // TODO: estimate gas 
    contractInstance.registerAsAuthor(authorName, authorEmail, {gas: 300000, from: web3.eth.accounts[0]}); 
  });
}

function isRegistered(){
  ShareD.deployed().then(function (contractInstance) {
    contractInstance.numberOfAuthors.call().then(function (count) {
        for(let i = 0; i < count; i++){
          contractInstance.allAuthorList.call(i).then(function (author) { 
            if(author[1] === web3.eth.accounts[0]){
                console.log('you are registered');
            }
          })
        }
      }); 
  });
}

function showArticleDetail(authorId, articleId){
  ShareD.deployed().then(function (contractInstance) { 
    contractInstance.articleList.call(authorId, articleId).then(function (article) { 
        console.log('articleId: ', article[0].toNumber());
        console.log('publishTime: ', article[1].toNumber());
        console.log('title: ', article[2]);
        console.log('briefIntro: ', article[3]);
        console.log('mdContentHash: ', article[4]);
        console.log('donationReceived: ', article[5].toNumber());
        console.log('authorId: ', article[6].toNumber());
    }) 
  })
}

function listAllArticles(){
  ShareD.deployed().then(function (contractInstance) {
    contractInstance.numberOfAuthors.call().then(function (count) {
        for(let i = 0; i < count; i++){
          contractInstance.allAuthorList.call(i).then(function (author) { 
            if(author[4].toNumber() > 0){
                for(let j = 0; j < author[4].toNumber(); j++){
                  contractInstance.articleList.call(author[0].toNumber(), j).then(function (article) { 
                    console.log('-----------------------')
                    console.log('articleId: ', article[0].toNumber());
                    console.log('publishTime: ', article[1].toNumber());
                    console.log('title: ', article[2]);
                    console.log('briefIntro: ', article[3]);
                    console.log('mdContentHash: ', article[4]);
                    console.log('donationReceived: ', article[5].toNumber());
                    console.log('authorId: ', article[6].toNumber());
                  }) 
                }
            }
          })
        }
      }); 
  });
}

window.addEventListener('load', async () => {
  if (window.ethereum) { // Modern dapp browsers...
      window.web3 = new Web3(ethereum);
      try {
          // Request account access if needed
          await ethereum.enable();
          // Accounts now exposed
          App.start();
      } catch (error) {
          // User denied account access...
      }
  } else if (window.web3) { // Legacy dapp browsers...
      window.web3 = new Web3(web3.currentProvider);
      web3.currentProvider.enable();
      // Accounts always exposed
      App.start();
  } else {  // Non-dapp browsers...
      console.log('Non-Ethereum browser detected. You should consider trying MetaMask!');
  }
});
