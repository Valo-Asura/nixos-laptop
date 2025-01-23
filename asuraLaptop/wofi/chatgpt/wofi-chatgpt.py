#!/usr/bin/env python3
from openai import OpenAI
import os
import sys
import argparse

def parse_arguments():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(description='OpenAI API Client')
    parser.add_argument('--api-key', help='OpenAI API key')
    return parser.parse_args()

def get_api_key(cmd_line_key=None):
    """Get API key from command file"""
    # API key file
    key_file = os.path.expanduser('~/.openai_api_key')
    if os.path.exists(key_file):
        with open(key_file, 'r') as f:
            return f.read().strip()
            
    return None

def initialize_client(api_key=None):
    """Initialize OpenAI client with API key"""
    if not api_key:
        raise ValueError(
            "OpenAI API key not found. Please provide it by this method:\n"
            "API key file: echo 'your-key' > ~/.openai_api_key"
        )
    return OpenAI(api_key=api_key)

def query_chatgpt(prompt, client):
    """Query ChatGPT with updated OpenAI API v1.0.0+ syntax"""
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",  # gpt-3.5-turbo
            messages=[
                {"role": "user", "content": prompt}
            ],
            max_tokens=50,  # Reduce max tokens
    temperature=0.7
        )
        return response.choices[0].message.content.strip()
    except Exception as e:
        return f"Error: {e}"

def main():
    try:
        # Parse command line arguments
        args = parse_arguments()
        
        # Get API key from various sources
        api_key = get_api_key(args.api_key)
        
        # Initialize client
        client = initialize_client(api_key)
        
        # Read prompt from stdin
        prompt = sys.stdin.read().strip()
        if not prompt:
            print("No input provided")
            sys.exit(1)
        
        print(query_chatgpt(prompt, client))
        
    except ValueError as e:
        print(f"Configuration Error: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()