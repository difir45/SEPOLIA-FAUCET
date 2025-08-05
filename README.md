# 🚰 Sepolia Faucet with Mainnet ETH Check

This is a simple and secure **Sepolia Testnet Faucet** designed to prevent spam and ensure fair distribution of test ETH.

---

## 🌟 Features

* ✅ Sends **0.1 Sepolia ETH** per request
* ✅ Only available to users with **≥ 0.1 ETH on Ethereum Mainnet**
* ⏳ Users can claim **once every 24 hours**
* 🔒 Prevents abuse and ensures testnet resources are used responsibly

---

## 🎯 Use Case

This faucet is perfect for:

* Developers testing their smart contracts on Sepolia
* Users who are active on Ethereum Mainnet and need Sepolia ETH
* Educational or demo projects that require a gated faucet

---

## 🛠 Tech Stack

* **Solidity** – Smart contract deployed on Sepolia
* **JavaScript + Ethers.js** – Frontend to interact with both Sepolia and Ethereum Mainnet
* **Infura / Alchemy** – Used to read Mainnet balances

---

## ⚙️ How It Works

1. User connects their wallet (MetaMask)
2. The app checks if the user has at least 0.1 ETH on **Ethereum Mainnet**
3. If eligible and 24 hours have passed since the last request, the contract sends **0.1 Sepolia ETH**

---

## 📌 Notes

* The contract must be pre-funded with Sepolia ETH to operate.
* Mainnet balance verification is done on the **frontend** using a remote provider.
* User activity is limited to one request per 24 hours to avoid draining the faucet.

---

## 📄 License

MIT – feel free to fork, build, and improve!

---

