import React, { Component } from 'react';
import { create } from 'ipfs-http-client';
import './App.css';
import NFTLaunchpad from '../abis/NFTLaunchpad.json';
import * as Constants from './Constants.js';
import * as Common from './Common.js';

const client = create('https://ipfs.infura.io:5001/api/v0')

class Home extends Component {

    async componentWillMount()  {
        await Common.loadWeb3();
        await this.loadBlockchainData();
        await this.runTimer();
    }

    async handleFile(event) {
        this.setState({fileURL: ''});
        const fileURL = event.target.files[0];
        if(fileURL.size > 30*1000*1000) {
            alert("file size exceeds 30 MB");
            return;
        }
        this.setState({fileURL});
        //console.log(fileURL);
    }
    async handleDesc(event) {
        this.setState({desc: ''});
        const desc = event.target.value;
        this.setState({desc});
        //console.log(desc + "--" + this.state.selectedToken);
    }

    async onBuyToken(event) {
        await this.nextAvailableToken();
        var result = await this.state.nftlp.methods.mint(this.state.nextAvailableToken).send({from: this.state.account, value: 5*10**16});
        //console.log("result: " + result.toString());
    }

    async onSubmit(event) {
        const file = this.state.fileURL;
        //console.log("file: " + file);
        if(!file) {
            alert("select a valid file");
            return;
        }
        try {
            const added = await client.add(file);
            const fileURL = `https://ipfs.infura.io/ipfs/${added.path}`;
            //console.log(fileURL);

            var result = await this.state.nftlp.methods.setTokenImage(this.state.selectedToken, fileURL, this.state.desc).send({from: this.state.account});
            //console.log("result: " + result.toString());
        } catch (error) {
            console.log('Error uploading file: ', error);
        }  
    }

    async availableTokens() {
        var supply = await this.state.nftlp.methods._maxSupply().call();
        var used = await this.state.nftlp.methods.totalSupply().call();
        this.setState({availableTokens: parseInt(supply) - parseInt(used)});
    }

    async nextAvailableToken() {
        const token = await this.state.nftlp.methods.nextAvailableToken().call();
        if(token) {
            this.setState({nextAvailableToken: token.toString()});
        }
    }

    async componentWillUnmount() {
        clearInterval(this.interval);
    }

    async loadBlockchainData()  {
        const accounts = await window.ethereum.request({ method: 'eth_accounts' });
        this.setState({account: accounts[0]});

        const nftlp = await window.web3.eth.Contract(NFTLaunchpad.abi, Constants.NFTLP_ADDRESS);
        this.setState({nftlp});
    }

    async runTimer()  {
        this.availableTokens();
        this.nextAvailableToken();
        //console.log("In runTimer");
    }

    constructor(props) {
        super(props);
        this.state = {
            account: '',
            fileURL: '',
            availableTokens: 0,
            nextAvailableToken: 0,
            selectedToken: 0
        };
        this.onSubmit = this.onSubmit.bind(this);
        this.handleFile = this.handleFile.bind(this);
        this.handleDesc = this.handleDesc.bind(this);
        this.availableTokens = this.availableTokens.bind(this);
        this.nextAvailableToken = this.nextAvailableToken.bind(this);
        this.onBuyToken = this.onBuyToken.bind(this);
        this.interval = setInterval(() => this.runTimer(), 10000);
    }

  render() {
    return (
      <div>
      <nav className="navbar navbar-expand-lg navbar-light bg-primary" >
        <div className="collapse navbar-collapse" id="navbarText">
            <ul className="navbar-nav mr-auto">
                <li id="menuStyle" > <a className="text-white" href="#" onClick={(event) => window.location.reload(false)}>nft-launchpad.io</a> </li>
            </ul>
            <span className="text-white" id="menuStyle" > {this.state.account} </span>
        </div>
      </nav>
      <p/>
      <div id="titleStyle" ><h4>NFT Launchpad</h4></div>
      <div id="aboutStyle" >
      Don't get lost on Opensea by having your collection. <p/>
      Join the "NFT Launchpad" collection on OpenSea and showcase your NFTs. <p/>
      "NFT Launchpad" collection is the one-stop shop for choosing NFTs from all budding artists.
      </div>
      <div id="titleStyle" ><h4>Step 1: Buy Token</h4></div>
      <p/>
      <table className="table" id="playersTable">
        <tbody>
            <tr>
                <td>Available Tokens</td>
                <td>{this.state.availableTokens}</td>
            </tr>
            <tr>
                <td>Next Available Token</td>
                <td>{this.state.nextAvailableToken}</td>
            </tr>
        </tbody>
      </table>
      <div id="titleStyle"><button onClick={this.onBuyToken} >Buy Token</button></div>
      <p/>
      <div id="titleStyle" ><h4>Step 2: Set Your NFT Image File and Description</h4></div>
      <p/>
      <table className="table" id="playersTable">
        <tbody>
            <tr>
                <td>File</td>
                <td><input type="file" id="nftFile" name="nftFile" accept="image/*,.mp4" onChange={this.handleFile}/></td>
            </tr>
            <tr>
                <td>Description</td>
                <td><input type="text" size="50" onChange={this.handleDesc}/></td>
            </tr>
            <tr>
                <td>Selected Token</td>
                <td><input type="text" size="10" onChange={(event) => this.setState({selectedToken: event.target.value})}/></td>
            </tr>
        </tbody>
      </table>
      <div id="titleStyle"><button onClick={this.onSubmit} >Submit</button></div>
      <p/>
      <div id="titleStyle" >
      <h4>Check Your NFT on Opensea at https://testnets.opensea.io/assets/{Constants.NFTLP_ADDRESS}/{this.state.selectedToken}</h4>
      </div>
      </div>
    );
  }
}

export default Home;
