import asyncio
import time
from aiohttp import ClientSession
from aiolimiter import AsyncLimiter

limiter = AsyncLimiter(1, 0.2)

async def fetch(url, session):
    async with limiter:
        async with session.get(url) as response:
            #ok
            if response.status == 200:
                print(url)
                return await response.read()

            #too many requests
            elif response.status == 429:
                    #retry after some time given by website
                    retry_after = response.headers.get("retry-after")
                    print("retry_after "+retry_after)
                    await asyncio.sleep(float(retry_after))
                    print("retrying: "+url)
                    return await fetch(url, session)

async def get_results(url_list):
    # Fetch all responses within one Client session,
    # keep connection alive for all requests.
    async with ClientSession() as session:
        tasks = []
        for url in url_list:
            task = asyncio.ensure_future(fetch(url, session))
            tasks.append(task)
        
        # gathered all results
        responses = await asyncio.gather(*tasks)
        
        result_list = []
        for response in responses:
            result_list.append(response)
        return result_list

def run_async(url_list):
    loop = asyncio.get_event_loop()
    start = time.time()
    future = asyncio.ensure_future(get_results(url_list))
    end = time.time()
    results = loop.run_until_complete(future)
    print(f"async took: {end - start} seconds")
    return results