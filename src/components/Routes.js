import React, { Component } from "react";
import { Router, Switch, Route } from "react-router-dom";

import Home from "./Home";
import CryptoPot from "./CryptoPot";
import LoveNFT from "./LoveNFT";
import history from './history';

export default class Routes extends Component {
    render() {
        return (
            <Router history={history}>
                <Switch>
                    <Route path="/" exact component={Home} />
                    <Route path="/CryptoPot" exact component={CryptoPot} />
                    <Route path="/lovenft" exact component={LoveNFT} />
                </Switch>
            </Router>
        )
    }
}
