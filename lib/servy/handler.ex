defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def log(conv) do
    IO.inspect(conv)
  end

  def parse(request) do
    # TODO: Parse the request string into a map:
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, status: 200, resp_body: ""}
  end

  def route(%{path: "/wildthings"}) do
    %{method: "GET", path: "/wildthings", status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%{path: "/bears"}) do
    %{method: "GET", path: "/wildthings", status: 200, resp_body: "Rahim, karim, jasim"}
  end

  def route(%{path: path}) do
    %{
      method: "GET",
      path: path,
      status: 404,
      resp_body: "something went wrong. path #{path} was not found"
    }
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.inspect(response)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.inspect(response)

request = """
GET /all HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.inspect(response)
