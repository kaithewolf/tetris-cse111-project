import asyncio
import time
from aiohttp import ClientSession

async def fetch(url, session):
    async with session.get(url) as response:
        return await response.read()

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
        #for response in responses:
        #    page = BeautifulSoup(response, "html.parser")
        #   title = page.find("title")
        #    print(repr(title))

def run_async(url_list):
    loop = asyncio.get_event_loop()
    start = time.time()
    future = asyncio.ensure_future(get_results(url_list))
    end = time.time()
    results = loop.run_until_complete(future)
    print(f"async took: {end - start} seconds")
    return results