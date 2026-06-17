output "python_api_url" {
    value = "${aws_api_gateway_stage.qa_environment.invoke_url}/${aws_api_gateway_resource.python_resource.path_part}?name=Kevin"
}

output "node_api_url" {
    value = "${aws_api_gateway_stage.qa_environment.invoke_url}/${aws_api_gateway_resource.node_resource.path_part}?name=Kevin"
}