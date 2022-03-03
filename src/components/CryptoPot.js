import React, { Component } from 'react';
import './App.css';
import CryptoPot from '../abis/CryptoPot.json';
import * as Constants from './Constants.js';
import * as Common from './Common.js';

class CryptoPotJS extends Component {

    async componentWillMount()  {
        await Common.loadWeb3();
        await this.loadBlockchainData();
        await this.runTimer();
    }

    async onSubmit(event) {
        await this.state.cpot.methods.joinContest(this.state.selectedToken).send({from: this.state.account, value: 5*10**16});
    }

    async componentWillUnmount() {
        clearInterval(this.interval);
    }

    async loadBlockchainData()  {
        const accounts = await window.ethereum.request({ method: 'eth_accounts' });
        this.setState({account: accounts[0]});

        const cpot = await window.web3.eth.Contract(CryptoPot.abi, Constants.CPOT_ADDRESS);
        this.setState({cpot});

        const priceWei = await this.state.cpot.methods._price().call();
        this.setState({price: window.web3.utils.fromWei(window.web3.utils.toBN(priceWei), "ether")});

        const prizeWei = await this.state.cpot.methods._winnerPrice().call();
        this.setState({winnerPrize: window.web3.utils.fromWei(window.web3.utils.toBN(prizeWei), "ether")});

        const availableTokens = await this.state.cpot.methods.availableTokens().call();
        this.setState({availableTokens});

        const count = (await this.state.cpot.methods.availableTokensCount().call());
        this.setState({availableTokensCount: count.toString()});
    }

    async runTimer()  {
        //console.log("In runTimer");
    }

    constructor(props) {
        super(props);
        this.state = {
            account: '',
            price: 0,
            winnerPrize: 0,
            selectedToken: 0,
            availableTokensCount: 0,
            availableTokens: ''
        };
        this.onSubmit = this.onSubmit.bind(this);
        this.interval = setInterval(() => this.runTimer(), 10000);
    }

  render() {
    return (
      <div>
      <nav className="navbar navbar-expand-lg navbar-light bg-primary" >
        <div className="collapse navbar-collapse" id="navbarText">
            <ul className="navbar-nav mr-auto">
                <li id="menuStyle" > <a className="text-white" href="/" >nft-launchpad.io</a> </li>
                <li id="menuStyle" > <a className="text-white" href="/cryptopot" >crypto-pot</a> </li>
                <li id="menuStyle" > <a className="text-white" href="/lovenft" >LoveNFT</a> </li>
            </ul>
            <span className="text-white" id="menuStyle" > {this.state.account} </span>
        </div>
      </nav>
      <p/>
      <div id="titleStyle" ><h4>Crypto Pot</h4></div>
      <div id="aboutStyle" >
      Choose a lucky token for {this.state.price} ETH and enter contest to win {this.state.winnerPrize} ETH <p/>
      </div>
      <div id="aboutStyle"> Available Tokens ({this.state.availableTokensCount}) <p/>
      {this.state.availableTokens}
      </div>
      <div id="aboutStyle"> Selected Token <p/>
      <input type="text" size="10" onChange={(event) => this.setState({selectedToken: event.target.value})}/></div>
      <div id="titleStyle"><button onClick={this.onSubmit} >Submit</button></div>
      <p/>
      <div id="aboutStyle" ><p/>contract: <a>{Constants.CPOT_ADDRESS}</a></div>
      <div id="aboutStyle" ><p/>twitter: <a href="https://twitter.com/srikumar_eth">@srikumar_eth</a></div>
      </div>
    );
  }
}

export default CryptoPotJS;
