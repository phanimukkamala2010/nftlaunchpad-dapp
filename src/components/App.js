import React, { Component } from 'react';
import Web3 from 'web3';
import './App.css';
import logo from './fcc.png'
import FantasyCricketCoin from '../abis/FantasyCricketCoin.json';
import MatchFCC from '../abis/MatchFCC.json';

class App extends Component {

    async componentWillMount()  {
        await this.loadWeb3();
        await this.loadBlockchainData();
        await this.getBalance();
        await this.getPlayers();
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

        const fcc = await window.web3.eth.Contract(FantasyCricketCoin.abi, FantasyCricketCoin.networks[networkId].address);
        this.setState({fcc});

        const match = await window.web3.eth.Contract(MatchFCC.abi, MatchFCC.networks[networkId].address);
        this.setState({match});
    }

    async callMint()    {
        //console.log("In callMint");
        await this.state.fcc.methods.mintCoin().send({from: this.state.account});
    }

    async callPlay()    {
        const owner = await this.state.fcc.methods.owner().call();
        console.log("In callPlay " + owner);
        await this.state.fcc.methods.transfer(owner, 2).send({from: this.state.account});
    }

    async getBalance()  {
        //console.log("In getBalance");
        const bal = await this.state.fcc.methods.balanceOf(this.state.account).call();
        this.setState({balance: bal.toString()});
    }

    async getPlayers()  {
        //console.log("In getPlayers");
        const playerCount = await this.state.match.methods.getPlayerCount().call();
        this.setState({playerCount});

        for(var i = 0; i < playerCount; ++i)
        {
            const playerName = await this.state.match.methods.getPlayer(i).call(); 
            const playerCost = await this.state.match.methods.getCost(i).call();
            //console.log("player=" + playerName + "," + playerCost);
            this.setState({ players: this.state.players.concat({name: playerName, cost: playerCost.toString(), points: "NA"}) });
        }
    }

    renderPlayerTable()  {
        return this.state.players.map((player, index) => {
            return (
                   <tr key={index}>
                    <td>{index + 1}</td>
                    <td>{player.name}</td>
                    <td>{player.cost}</td>
                    <td>{player.points}</td>
                   </tr>
                   );
        });
    }

    constructor(props) {
        super(props);
        this.state = {
            account: '',
            balance: 0,
            playerCount: 0,
            players: []
        };
        this.callMint = this.callMint.bind(this);
        this.callPlay = this.callPlay.bind(this);
        this.interval = setInterval(() => this.getBalance(), 10000);
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
      <div id="titleStyle" ><h3>10/Oct/2021,  Match - India vs NZ</h3></div>
      <table className="table" id="playersTable">
        <thead>
            <tr width="20%">
                <th scope="col" >ID</th>
                <th scope="col" >PLAYER</th>
                <th scope="col" >COST</th>
                <th scope="col" >POINTS</th>
            </tr>
        </thead>
        <tbody className="playersStyle" >
            {this.renderPlayerTable()}
        </tbody>
      </table>
      <table className="table" id="playersTable">
        <thead>
            <tr width="20%">
                <th scope="col" >ID</th>
                <th scope="col" >PLAYER</th>
                <th scope="col" >COST</th>
                <th scope="col" >POINTS</th>
            </tr>
        </thead>
        <tbody className="playersStyle" >
            {this.renderPlayerTable()}
        </tbody>
      </table>
      <button type="submit" id="buttonStyle" className="btn btn-outline-primary" onClick={(event) => this.callPlay() }>Play</button>
      </div>
    );
  }
}

export default App;
