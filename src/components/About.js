import React, { Component } from 'react';
import './App.css';
import FantasyCricketCoin from '../abis/FantasyCricketCoin.json';
import MatchFCC from '../abis/MatchFCC.json';
import * as Constants from './Constants.js';
import * as Common from './Common.js';

class About extends Component {

    async componentWillMount()  {
        await Common.loadWeb3();
        await this.loadBlockchainData();
        await this.runTimer();
    }

    async componentWillUnmount()    {
        clearInterval(this.interval);
    }

    async callMint()    {
        //console.log("In callMint");
        await this.state.fcc.methods.mintCoin().send({from: this.state.account});
    }

    async loadBlockchainData()  {
        const accounts = await window.ethereum.request({ method: 'eth_accounts' });
        this.setState({account: accounts[0]});

        const fcc = await window.web3.eth.Contract(FantasyCricketCoin.abi, Constants.FCC_ADDRESS);
        this.setState({fcc});

        const match = await window.web3.eth.Contract(MatchFCC.abi, Constants.MATCH_ADDRESS);
        this.setState({match});
    }

    async runTimer()  {
        //console.log("In runTimer");
        await this.getBalance();
    }

    async getBalance() {
        const bal = await this.state.fcc.methods.balanceOf(this.state.account).call();
        if(bal) {
                this.setState({balance: bal.toString()});
        }
    }

    constructor(props) {
        super(props);
        this.state = {
            account: '',
            balance: 0
        };
        this.callMint = this.callMint.bind(this);
        this.interval = setInterval(() => this.runTimer(), 10000);
    }

  render() {
    return (
      <div>
      <nav className="navbar navbar-expand-lg navbar-light bg-primary" >
        <div className="collapse navbar-collapse" id="navbarText">
            <ul className="navbar-nav mr-auto">
                <li id="menuStyle" > <a className="text-white" href="/" >FCC-Cricket</a> </li>
                <li id="menuStyle" > <a className="text-white" href="/Results">Results</a> </li>
                <li id="menuStyle" > <a className="text-white" href="/About">About</a> </li>
                <li className="nav-item" >
                { this.state.balance == 0 ?
                    (<a className="text-white" id="menuStyle" href="javascript:void(0)" onClick={(event) => this.callMint()} >Mint</a>)
                    :
                    (<span />)
                }
                </li>
                
            </ul>
            <span className="text-white" id="menuStyle" > {this.state.account} ({this.state.balance} FCC) </span>
        </div>
      </nav>
      <div id="aboutStyle" >
      <h4>About FCC</h4>
      <p/>
      Welcome to FCC-Cricket.   <p/>
      For playing on FCC-Cricket you will need FCC (Fantasy Cricket Coin).  <p/>
      Fantasy Cricket Coin or FCC is a coin built on Ethereum blockchain.   <p/>
      Every new address will be able to mint 100 FCC coins. <p/>
      <p/> <p/> <p/>
      <i>FCC Contract: {Constants.FCC_ADDRESS} </i>
      </div>
      </div>
    );
  }
}

export default About;
