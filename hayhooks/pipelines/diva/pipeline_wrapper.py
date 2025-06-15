import os
from typing import Union, List, AsyncGenerator

from hayhooks import BasePipelineWrapper, log
from hayhooks import get_last_user_message, async_streaming_generator

from haystack import AsyncPipeline
from haystack.core.component import component
from haystack.dataclasses.chat_message import ChatMessage
from haystack.components.builders.prompt_builder import PromptBuilder

from haystack_integrations.components.generators.ollama import OllamaGenerator

from postgres_connection import get_postgres_connection
from diva_sql import SQL_GET_MACHINE


OLLAMA_URL = os.getenv("OLLAMA_URI", "http://localhost:7869")

SYSTEM_MESSAGE = """
Given the following machine description, perform an analysis of the maintenance 
tickets and spare parts used.

Summarize the information using markdown tables.

Context:
{{ machine }}

Question: {{ question }}
"""

@component
class MachineFetcher:
    @component.output_types(machine=dict)
    def run(self, machine_id: int):
        conn = get_postgres_connection()
        print("Successfully connected to PostgreSQL!")
        
        with conn.cursor() as cursor:
            cursor.execute(
                SQL_GET_MACHINE, 
                {"machine_id": machine_id}
            )
            machine = cursor.fetchone()
            print(f"Machine: {machine}")
            
        conn.close()

        return {"machine": machine}


class PipelineWrapper(BasePipelineWrapper):
    def setup(self) -> None:
        self.pipeline = AsyncPipeline()
        self.pipeline.add_component("machine_fetcher", MachineFetcher())
        self.pipeline.add_component("prompt_builder", PromptBuilder(
            template=SYSTEM_MESSAGE,
            required_variables=["machine"]
        ))
        self.pipeline.add_component("generator", OllamaGenerator(
            model="gemma3", 
            url=OLLAMA_URL,
            timeout=10*60
        ))

        self.pipeline.connect("machine_fetcher", "prompt_builder")
        self.pipeline.connect("prompt_builder", "generator")
        

    async def run_api_async(self, machine_id: int) -> str:
        log.trace(f"Describing machine with id {machine_id}")
        
        result = await self.pipeline.run_async(
            {
                "machine_fetcher": {"machine_id": machine_id},
                "prompt_builder": {"question": "Describe the given data"}
            },
            include_outputs_from=["generator"]
        )
        
        return result["generator"]["replies"][0]

    # async def run_chat_completion_async(self, model: str, messages: List[dict], body: dict) -> AsyncGenerator:
    #     log.trace(f"Running pipeline with model: {model}, messages: {messages}, body: {body}")
    #     question = get_last_user_message(messages)
    #     log.trace(f"Question: {question}")
    #     return async_streaming_generator(
    #         pipeline=self.pipeline,
    #         pipeline_run_args={
    #             "prompt_builder": {
    #                 "template": [
    #                     ChatMessage.from_system(SYSTEM_MESSAGE),
    #                     ChatMessage.from_user(question),
    #                 ]
    #             },
    #         },
    #     )
    

if __name__ == '__main__':
    import os
    os.environ['DB_NAME'] = 'postgres'
    os.environ['DB_USER'] = '__PG_USER__'
    os.environ['DB_PASSWORD'] = '__PG_PASS__'
    MachineFetcher().run(machine_id=1)