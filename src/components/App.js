import React, { Component } from 'react';
import Web3 from 'web3';
import './App.css';
import logo from './fcc.png'
import FantasyCricketCoin from '../abis/FantasyCricketCoin.json';

class App extends Component {

    async componentWillMount()  {
        await this.loadWeb3();
        await this.loadBlockchainData();
        await this.getBalance();
    }

    async componentWillUnmount()    {
        clearInterval(this.interval);
    }

    async loadWeb3() {
        window.addEventListener('load', async () => {
            if (window.ethereum) {
                window.web3 = new Web3(window.ethereum);
                await window.ethereum.enable();
            }
            else if (window.web3) {
                window.web3 = new Web3(window.web3.currentProvider);
            }
            else {
                console.log('Non-Ethereum browser detected. You should consider trying MetaMask!');
            }
        });
    }

    async loadBlockchainData()  {
        const accounts = await window.ethereum.request({ method: 'eth_accounts' });
        this.setState({account: accounts[0]});

        const networkId = await window.web3.eth.net.getId();
        const networkData = FantasyCricketCoin.networks[networkId];
        //console.log(networkId);
        if(networkData) {
            const fcc = await window.web3.eth.Contract(FantasyCricketCoin.abi, networkData.address);
            this.setState({fcc});
        }
    }

    async callMint()    {
        //console.log("In callMint");
        await this.state.fcc.methods.mintCoin().send({from: this.state.account}).then(this.getBalance());
    }

    async getBalance()  {
        //console.log("In getBalance");
        const account = this.state.account;
        const bal = await this.state.fcc.methods.balanceOf(this.state.account).call();
        this.setState({balance: bal.toString()});
    }

    constructor(props) {
        super(props);
        this.state = {
            account: '',
            balance: 0,
        };
        this.callMint = this.callMint.bind(this);
        this.interval = setInterval(() => this.getBalance(), 5000);
    }

  render() {
    return (
      <div>
      <nav className="navbar navbar-expand-lg navbar-light bg-primary">
        <img src={logo} width="120" height="60" className="align-top" alt="" />
        <a className="navbar-brand text-white" href="#">FCC-Cricket</a>
        <div className="collapse navbar-collapse" id="navbarText">
            <ul className="navbar-nav mr-auto">
                <li className="nav-item">
                { this.state.balance == 0 ?
                    (<a className="nav-link text-white" href="javascript:void(0)" onClick={(event) => this.callMint()} >Mint</a>)
                    :
                    (<a className="nav-link text-white disabled" href="javascript:void(0)" onClick={(event) => this.callMint()} >Mint</a>)
                }
                </li>
                
            </ul>
            <span className="navbar-text text-white"> {this.state.account} </span>
            <span className="navbar-text text-white"> ({this.state.balance} FCC) </span>
        </div>
      </nav>
      </div>
    );
  }
}

export default App;
