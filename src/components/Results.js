import React, { Component } from 'react';
import './App.css';
import FantasyCricketCoin from '../abis/FantasyCricketCoin.json';
import MatchFCC from '../abis/MatchFCC.json';
import * as Constants from './Constants.js';
import * as Common from './Common.js';

class Results extends Component {

    async componentWillMount()  {
        await Common.loadWeb3();
        await this.loadBlockchainData();
        await this.getPlayers();
        await this.runTimer();
        await this.getPreviousSelectedPlayers();
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
        await this.getBalance();
        await this.getFccPaid();
    }

    async getBalance() {
        const bal = await this.state.fcc.methods.balanceOf(this.state.account).call();
        if(bal) {
                this.setState({balance: bal.toString()});
        }
    }

    async getFccPaid() {
        const owner = await this.state.fcc.methods.owner().call();
        const blockNumber = await this.state.match.methods.getBlockNumber().call();
        const account = this.state.account;
        var paid = 0;
        await this.state.fcc.getPastEvents('Transfer', { fromBlock: blockNumber }).then(function(events) { 
            for(var i = 0; i < events.length; ++i) {
                if(events[i].returnValues.from.toLowerCase() == account.toLowerCase() && 
                   events[i].returnValues.to.toLowerCase() == owner.toLowerCase()) {
                    paid += parseInt(events[i].returnValues.value);
                    //console.log("filtered " + events[i].returnValues.from + "=>" + events[i].returnValues.to + " " + events[i].returnValues.value + "," + paid);
                }
            }
        });
        this.setState({fccPaid: paid});
        //console.log("fccPaid=" + this.state.fccPaid);
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

    async getPreviousSelectedPlayers()  {
        var playerStr = await this.state.match.methods.getMatchPlayers().call({from: this.state.account});
        if(playerStr != null && !playerStr.includes(':')) {
            return;
        }
        playerStr = playerStr.replace(';', ':');
        const playerArray = playerStr.split(":");
        var cost = 0;
        var points = 0;
        for(var i = 0; i < 11; ++i) {
            //console.log(playerArray[i]);
            const playerName = await this.state.match.methods.getPlayer(playerArray[i]).call(); 
            const playerCost = await this.state.match.methods.getCost(playerArray[i]).call();
            cost += parseInt(playerCost.toString());
            const playerPoints = await this.state.match.methods.getPoints(playerArray[i]).call();
            points += parseInt(playerPoints.toString());
            this.setState({ previousSelectedPlayers: this.state.previousSelectedPlayers.concat({name: playerName, cost: playerCost.toString(), points: playerPoints.toString()}) });
        }
        this.setState({previousSelectedPlayersCost: cost});
        this.setState({previousSelectedPlayersPoints: points});
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
    renderPreviousSelectedPlayerTable()  {
        return this.state.previousSelectedPlayers.map((player, index) => {
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
            fccPaid: 0,
            playerCount: 0,
            players: [],
            selectedPlayers: [],
            selectedPlayersCost: 0,
            selectedPlayersPoints: 0,
            previousSelectedPlayers: [],
            previousSelectedPlayersCost: 0,
            previousSelectedPlayersPoints: 0,
            checkedPlayers: []
        };
        this.callMint = this.callMint.bind(this);
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
      <div id="titleStyle" ><h4>10/Oct/2021,  Match - India vs NZ</h4></div>
      </div>
    );
  }
}

export default Results;
