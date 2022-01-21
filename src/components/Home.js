import React, { Component } from 'react';
import './App.css';
import FantasyCricketCoin from '../abis/FantasyCricketCoin.json';
import MatchFCC from '../abis/MatchFCC.json';
import * as Constants from './Constants.js';
import * as Common from './Common.js';

class Home extends Component {

    async componentWillMount()  {
        await Common.loadWeb3();
        await this.loadBlockchainData();
        await this.getPlayers();
        await this.runTimer();
    }

    async componentWillUnmount()    {
        clearInterval(this.interval);
    }

    async loadBlockchainData()  {
        const accounts = await window.ethereum.request({ method: 'eth_accounts' });
        this.setState({account: accounts[0]});

        const fcc = await window.web3.eth.Contract(FantasyCricketCoin.abi, Constants.FCC_ADDRESS);
        this.setState({fcc});

        const match = await window.web3.eth.Contract(MatchFCC.abi, Constants.MATCH_ADDRESS);
        this.setState({match});
    }

    async callPlay()    {
        const owner = await this.state.fcc.methods.owner().call();
        //console.log("In callPlay " + owner + "-" + playerStr + "-" + cost);
        await this.state.fcc.methods.transfer(owner, 1).send({from: this.state.account});
    }

    async callConfirmPlayers()    {
        var playerstr = 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[0].name).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[1].name).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[2].name).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[3].name).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[4].name).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[5].name).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[6].name).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[7].name).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[8].name).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[9].name).call() + ":" + 
                await this.state.match.methods.getPlayerIndex(this.state.selectedPlayers[10].name).call() + ";";
        //console.log(playerstr);
        this.state.match.methods.addMatchPlayers(playerstr).send({from: this.state.account}).on('transactionHash', function(hash) {
            //console.log("hash-" + hash);
        });

        //console.log("In callPlay " + "-" + playerstr);
    }

    async runTimer()  {
        //console.log("In runTimer");
    }

    async getPlayers()  {
        //console.log("In getPlayers");
        const playerCount = await this.state.match.methods.getPlayerCount().call();
        this.setState({playerCount});

        for(var i = 0; i < playerCount; ++i)
        {
            const playerName = await this.state.match.methods.getPlayer(i).call(); 
            const playerCost = await this.state.match.methods.getCost(i).call();
            const playerPoints = await this.state.match.methods.getPoints(i).call();
            //console.log("player=" + playerName + "," + playerCost);
            this.setState({ players: this.state.players.concat({name: playerName, cost: playerCost.toString(), points: playerPoints.toString()}) });
        }
    }

    async getSelectedPlayersTotal() {
        var cost = 0;
        var points = 0;
        for(var i = 0; i < 22; ++i) {
            if(this.state.checkedPlayers[i]) {
                cost += parseInt(await this.state.match.methods.getCost(i).call());
                points += parseInt(await this.state.match.methods.getPoints(i).call());
            }
        }
        this.setState({selectedPlayersCost: cost});
        this.setState({selectedPlayersPoints: points});
    }

    async onChange(event)  {
        //console.log("called onChange " + id.index + " " + JSON.stringify(id) + " " + event.target.checked + " " + event.target.id);
        const checked = event.target.checked;
        const index = event.target.id;
        this.state.checkedPlayers[event.target.id] = checked;
        const playerName = await this.state.match.methods.getPlayer(index).call(); 
        const playerCost = await this.state.match.methods.getCost(index).call();
        const playerPoints = await this.state.match.methods.getPoints(index).call();
        
        this.setState({ selectedPlayers: this.state.selectedPlayers.filter( function(_player) {
            return _player.name != playerName;
        }) });
        if(checked) {
            this.setState({ selectedPlayers: this.state.selectedPlayers.concat({name: playerName, cost: playerCost.toString(), points: playerPoints.toString()}) });
        }
        this.getSelectedPlayersTotal();
    }

    renderPlayerTable()  {
        const count = this.state.selectedPlayers.length;
        return this.state.players.map((player, index) => {
            const checked = this.state.checkedPlayers[index];
            return (
                   <tr key={index}>
                    <td>{index + 1}</td>
                    <td>{player.name}</td>
                    <td>{player.cost}</td>
                    <td>{player.points}</td>
                    <td>
                     <div className="form-check">
                      <input className="form-check-input" disabled={count >= 11 && !checked} type="checkbox" id={index} onChange={(event)=> this.onChange(event)}/>
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
            players: [],
            selectedPlayers: [],
            selectedPlayersCost: 0,
            selectedPlayersPoints: 0,
            checkedPlayers: []
        };
        this.callPlay = this.callPlay.bind(this);
        this.callConfirmPlayers = this.callConfirmPlayers.bind(this);
        this.getSelectedPlayersTotal = this.getSelectedPlayersTotal.bind(this);
        this.onChange = this.onChange.bind(this);
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
      <div id="titleStyle" ><h4>NFT Launch Pad</h4></div>
      <div id="aboutStyle" >
      Don't get lost on Opensea by having your collection. <p/>
      Join the "NFT Launch Pad" collection on OpenSea and showcase your NFTs. <p/>
      "NFT Launch Pad" collection is the one-stop shop for choosing NFTs from all budding artists.
      </div>
      <div id="titleStyle" ><h4>Step 1: Buy Token</h4></div>
      <table className="table" id="playersTable">
        <tbody className="playersStyle" >
            <tr>
                <td>Available Tokens</td>
                <td>{this.state.selectedPlayersPoints}</td>
            </tr>
            <tr>
                <td>Next Available Token</td>
                <td>{this.state.selectedPlayersPoints}</td>
            </tr>
            <tr>
                <td>Buy Token</td>
                <td>{this.state.selectedPlayersPoints}</td>
            </tr>
        </tbody>
      </table>
      <div id="titleStyle" ><h4>Step 2: Select File and Set Description</h4></div>
      <table className="table" id="playersTable">
        <tbody className="playersStyle" >
            <tr>
                <td>File</td>
                <td>{this.state.selectedPlayersPoints}</td>
            </tr>
            <tr>
                <td>Description</td>
                <td>{this.state.selectedPlayersPoints}</td>
            </tr>
        </tbody>
      </table>
      <table className="table" id="buttonTable">
        <tbody>
         <tr>
          <td>
           <button type="submit" disabled={this.state.selectedPlayers.length != 11} id="buttonStyle" className="btn btn-outline-primary" onClick={(event) => this.callConfirmPlayers() }>Confirm Players</button>
          </td>
         </tr>
        </tbody>
      </table>
      </div>
    );
  }
}

export default Home;
