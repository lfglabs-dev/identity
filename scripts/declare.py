import logging
from asyncio import run

from utils.constants import COMPILED_CONTRACTS
from utils.starknet import declare_v2, dump_declarations, get_starknet_account

# Set up logging
logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


async def main():
    account = await get_starknet_account()
    logger.info("ℹ️  Using account %s as deployer", hex(account.address))

    class_hash = {
        contract["contract_name"]: await declare_v2(contract["contract_name"])
        for contract in COMPILED_CONTRACTS
    }
    dump_declarations(class_hash)


if __name__ == "__main__":
    run(main())
