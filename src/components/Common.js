import Web3 from 'web3';

export function loadWeb3() {
        window.addEventListener('load', async () => {
            if (window.ethereum) {
                window.web3 = new Web3(window.ethereum);
                await window.ethereum.enable();
            }
            else if(window.web3) {
                window.web3 = new Web3(window.web3.currentProvider);
            }
        });
    }
