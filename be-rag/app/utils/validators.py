from langchain_experimental.tools.python.tool import sanitize_input

def sanitize_string(string: str) -> str:
    """
    Sanitize a string by converting it to lowercase and stripping whitespaces and injections.
    """
    return sanitize_input(string).lower().strip()