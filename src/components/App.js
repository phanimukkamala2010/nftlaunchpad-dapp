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
        const playerStr = await this.state.match.methods.getMatchPlayers().call({from: this.state.account});
        const cost = await this.state.match.methods.getMatchCost().call({from: this.state.account});
        const owner = await this.state.fcc.methods.owner().call();
        console.log("In callPlay " + owner + "-" + playerStr + "-" + cost);
        await this.state.fcc.methods.transfer(owner, 2).send({from: this.state.account});
    }

    async callConfirmPlayers()    {
        var playerstr = 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[0]).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[1]).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[2]).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[3]).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[4]).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[5]).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[6]).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[7]).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[8]).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[9]).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[10]).call() + ";";
        //console.log(playerstr);
        await this.state.match.methods.addMatchPlayers(playerstr).send({from: this.state.account});

        //console.log("In callPlay " + "-" + playerstr);
    }

    async getBalance()  {
        //console.log("In getBalance");
        const bal = await this.state.fcc.methods.balanceOf(this.state.account).call();
        if(bal) {
                this.setState({balance: bal.toString()});
        }
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

    async onChange(event, id)  {
        //console.log("called onChange " + id.index + " " + JSON.stringify(id) + " " + event.target.checked + " " + event.target.id);
        const checked = event.target.checked;
        const playerName = await this.state.match.methods.getPlayer(event.target.id).call(); 
        
        this.setState({ selectedPlayers: this.state.selectedPlayers.filter( function(name) {
            return name != playerName;
        }) });
        if(checked)    {
            this.setState({ selectedPlayers: this.state.selectedPlayers.concat(playerName) });
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
                    <td>
                     <div className="form-check">
                     <input className="form-check-input" type="checkbox" value="" id={index} onChange={(event)=> this.onChange(event, {index})}/>
                     </div>
                    </td>
                   </tr>
                   );
        });
    }
    renderSelectedPlayerTable()  {
        return this.state.selectedPlayers.map((player, index) => {
            return (
                   <tr key={index}>
                    <td>{index + 1}</td>
                    <td>{player}</td>
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
            players: [],
            selectedPlayers: []
        };
        this.callMint = this.callMint.bind(this);
        this.callPlay = this.callPlay.bind(this);
        this.callConfirmPlayers = this.callConfirmPlayers.bind(this);
        this.onChange = this.onChange.bind(this);
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
                <th scope="col" >SELECT</th>
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
                <th scope="col" >SELECTED PLAYER</th>
                <th scope="col" >COST</th>
                <th scope="col" >POINTS</th>
            </tr>
        </thead>
        <tbody className="playersStyle" >
            {this.renderSelectedPlayerTable()}
        </tbody>
      </table>
      <table className="table" id="buttonTable">
        <tbody>
         <tr>
          <td>
           <button type="submit" id="buttonStyle" className="btn btn-outline-primary" onClick={(event) => this.callConfirmPlayers() }>Confirm Players</button>
          </td>
          <td>
           <button type="submit" id="buttonStyle" className="btn btn-outline-primary" onClick={(event) => this.callPlay() }>Play</button>
          </td>
         </tr>
        </tbody>
      </table>
      </div>
    );
  }
}

export default App;
