# %% Imports
import logging
from asyncio import run
from dotenv import load_dotenv
import os

load_dotenv()
NETWORK = os.getenv("STARKNET_NETWORK", "devnet")

from utils.constants import COMPILED_CONTRACTS, ETH_TOKEN_ADDRESS
from utils.starknet import (
    deploy_v2,
    declare_v2,
    dump_declarations,
    get_starknet_account,
    dump_deployments,
)

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
# https://api.starknet.id/uri?id=
MAINNET_CONST = [0x68747470733A2F2F6170692E737461726B6E65742E69642F7572693F69643D]
# https://goerli.api.starknet.id/uri?id="
GOERLI_CONST = [
    0x68747470733A2F2F676F65726C692E6170692E737461726B6E65742E69642F,
    0x7572693F69643D,
]


# %% Main
async def main():
    # %% Declarations
    account = await get_starknet_account()
    logger.info("ℹ️  Using account %s as deployer", hex(account.address))

    class_hash = {
        contract["contract_name"]: await declare_v2(contract["contract_name"])
        for contract in COMPILED_CONTRACTS
    }
    dump_declarations(class_hash)

    deployments = {}
    deployments["identity_Identity"] = await deploy_v2(
        "identity_Identity", account.address, (MAINNET_CONST if NETWORK == "mainnet" else GOERLI_CONST)
    )

    dump_deployments(deployments)


# %% Run
if __name__ == "__main__":
    run(main())
