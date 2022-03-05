import React, { Component } from 'react';
import './App.css';
import LoveNFT from '../abis/LoveNFT.json';
import * as Constants from './Constants.js';
import * as Common from './Common.js';

let svgStr1 = "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 350 350\">";
let svgStr2 = "<path d=\"M 0 0 v 350 h 350 v -350 \" style=\"fill:bgColor; stroke: grey; stroke-width: 0.5\" />";
let svgStr3 = "<text x=\"40\" y=\"30\" text-anchor=\"start\" style=\"fill:black;stroke:black;stroke-width:0.1;font-size:15px\" font-style=\"italic\" >topName</text>";
let svgStr4 = "<path d=\"M 175,95 a 40,30 0 0 0 -100,0 v 20 a 150,150 0 0 0 100,120 a 150,150 0 0 0 100,-120 v -20 a 40,30 0 0 0 -100,0 z\" style=\"fill:heartColor;stroke:heartColor;stroke-width:5;\" />";
let svgStr5 = "<text x=\"310\" y=\"270\" text-anchor=\"end\" style=\"fill:black;stroke:black;stroke-width:0.1;font-size:15px\" font-style=\"italic\" >bottomName</text>";
let svgStr6 = "<text x=\"30\" y=\"290\" style=\"fill:black;stroke:black;stroke-width:0.1;font-size:10px\">message1</text>";
let svgStr7 = "<text x=\"30\" y=\"300\" style=\"fill:black;stroke:black;stroke-width:0.1;font-size:10px\">message2 </text>";
let svgStr8 = "<text x=\"30\" y=\"310\" style=\"fill:black;stroke:black;stroke-width:0.1;font-size:10px\">message3 </text>";
let svgStr9 = "<text x=\"30\" y=\"320\" style=\"fill:black;stroke:black;stroke-width:0.1;font-size:10px\">message4 </text>";
let svgStr10 = "<path d=\"M 340,327 v 7 h 1 v -5 z\" style=\"fill:silver;stroke:silver;stroke-width:1\" />";
let svgStr11 = "<circle cx=\"340\" cy=\"341\" r=\"6\" style=\"fill:silver;stroke:silver;stroke-width:1\" />";
let svgStr12 = "<text x=\"336\" y=\"342\" style=\"fill:gold;stroke:gold;stroke-width:0.5;font-size:5px\" >NFT</text>";
let svgStr13 = "<text x=\"2\" y=\"348\" style=\"fill:black;stroke:black;stroke-width:0.1;font-size:5px\" >todaydate</text></svg>";

let months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
let mapColors = new Map();

class LoveNFTJS extends Component {

    async componentWillMount()  {
        await Common.loadWeb3();
        await this.loadBlockchainData();
        await this.runTimer();
    }

    async onSubmit(event) {
        let year = new Date().getFullYear();
        let month = new Date().getMonth();
        let day = new Date().getDate();
        let todayDate = day + "-" + months[month] + "-" + year;

        let svgStrFull = svgStr1.concat(svgStr2, svgStr3, svgStr4, svgStr5, svgStr6);
        svgStrFull = svgStrFull.concat(svgStr7, svgStr8, svgStr9, svgStr10, svgStr11, svgStr12, svgStr13);
        svgStrFull = svgStrFull.replace("bgColor", mapColors.get(this.state.heartColor));
        svgStrFull = svgStrFull.replaceAll("heartColor", this.state.heartColor);
        svgStrFull = svgStrFull.replace("topName", this.state.topName);
        svgStrFull = svgStrFull.replace("bottomName", this.state.bottomName);
        svgStrFull = svgStrFull.replace("message1", this.state.message1);
        svgStrFull = svgStrFull.replace("message2", this.state.message2);
        svgStrFull = svgStrFull.replace("message3", this.state.message3);
        svgStrFull = svgStrFull.replace("message4", this.state.message4);
        svgStrFull = svgStrFull.replace("todaydate", todayDate);
        await this.state.lovenft.methods.mint(svgStrFull.toString()).send({from: this.state.account, value: 69*10**15});
    }

    async componentWillUnmount() {
        clearInterval(this.interval);
    }

    async loadBlockchainData()  {
        const accounts = await window.ethereum.request({ method: 'eth_accounts' });
        this.setState({account: accounts[0]});

        const lovenft = await window.web3.eth.Contract(LoveNFT.abi, Constants.LOVENFT_ADDRESS);
        this.setState({lovenft});

        const priceWei = await this.state.lovenft.methods._price().call();
        this.setState({price: window.web3.utils.fromWei(window.web3.utils.toBN(priceWei), "ether")});

        const used = 1 + parseInt(await this.state.lovenft.methods.totalSupply().call());
        this.setState({nextToken: used});
    }

    async runTimer()  {
        //console.log("In runTimer");
    }

    constructor(props) {
        super(props);
        this.state = {
            account: '',
            price: 0,
            nextToken: 0,
            topName: '',
            bottomName: '',
            message1: '',
            message2: '',
            message3: '',
            message4: ''
        };
        mapColors.set('blue', 'azure');
        mapColors.set('red', 'pink');
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
      <div id="titleStyle" ><h4>Love NFT</h4></div>
      <div id="aboutStyle" >
      Create a love message NFT on blockchain. ({this.state.price} E)
      </div>
      <div id="aboutStyle"> Next Token ({this.state.nextToken}) <p/>
      </div>
      <table className="table" id="playersTable">
        <tbody>
            <tr>
                <td>Top Name (max 64)</td>
                <td><input type="text" size="64" onChange={(event) => this.setState({topName: event.target.value})}/></td>
            </tr>
            <tr>
                <td>Bottom Name (max 64) </td>
                <td><input type="text" size="64" onChange={(event) => this.setState({bottomName: event.target.value})}/></td>
            </tr>
            <tr>
                <td>Love Color </td>
                <td className="select" onChange={(event) => this.setState({heartColor: event.target.value})}>
                <select>
                    <option value="red">Red</option>
                </select>
                </td>
            </tr>
            <tr>
                <td> Message Line 1 (max 80) </td>
                <td><input type="text" size="80" onChange={(event) => this.setState({message1: event.target.value})}/></td>
            </tr>
            <tr>
                <td> Message Line 2 (max 80) </td>
                <td><input type="text" size="80" onChange={(event) => this.setState({message2: event.target.value})}/></td>
            </tr>
            <tr>
                <td> Message Line 3 (max 80) </td>
                <td><input type="text" size="80" onChange={(event) => this.setState({message3: event.target.value})}/></td>
            </tr>
            <tr>
                <td> Message Line 4 (max 80) </td>
                <td><input type="text" size="80" onChange={(event) => this.setState({message4: event.target.value})}/></td>
            </tr>
        </tbody>
      </table>
      <div id="titleStyle"><button onClick={this.onSubmit} >Submit</button></div>
      <p/>
      <div id="aboutStyle" ><p/>contract: <a>{Constants.LOVENFT_ADDRESS}</a></div>
      <div id="aboutStyle" ><p/>twitter: <a href="https://twitter.com/srikumar_eth">@srikumar_eth</a></div>
      </div>
    );
  }
}

export default LoveNFTJS;
