payload 
{
  "nome": "iPhone 15 Pro Display",
  "descricao": "High quality replacement display",
  "tipo": "hardware",
  "ncm": "85177010",
  "origem_fiscal": "0",
  "cfop_padrao": "5102",
  "requires_invoice": true,
  "variants": [
    {
      "nome": "Azul",
      "codigo": "AZ-01",
      "atributo": "Cor",
      "cor": "#0000FF"
    }
  ]
}
api/v1/products
endpoints
/api/v1/products
Post
Create a new product definition

GET
/api/v1/products
List all products

GET
/api/v1/products/variants
List all product variants

GET
/api/v1/products/bundles
List all product bundles

PUT
/api/v1/products/{id}
Update a product definition

DELETE
/api/v1/products/{id}
Delete a product definition


[
  {
    "product_sk": 100,
    "product_id": "PRD-001",
    "company_id": "uuid-company",
    "nome": "Impressora 3D",
    "descricao": "Impressora industrial",
    "tipo": "hardware",
    "ncm": "84433210",
    "origem_fiscal": "0",
    "cfop_padrao": "5102",
    "requires_invoice": true,
    "effective_date": "2026-04-30T01:06:57.782Z",
    "end_date": "2026-04-30T01:06:57.782Z",
    "is_current": true,
    "created_at": "2026-04-30T01:06:57.782Z"
  }
]


temos uma situacao, produtos, tem a entidade produto, porem tem tb o model produtosmodel que se comunica no servidor ok, ate ai sem problemas, o formulario deve transformar esses dados em dto passar para o usecase via entidade, que manda para repo que converte para model, retorna os dados em json no sorce, converte pra model pelo factory, devolve pra repo que converte em entidade ate tb ok, porem os dados que envio para o servidor nao sao os mesmo que eu recebo como resposta pq o server tem regras la e triggers no banco de dados entao, como eu faco essa abordagem, o payload para enviar ao servidor eh essa
payload 
{
  "nome": "iPhone 15 Pro Display",
  "descricao": "High quality replacement display",
  "tipo": "hardware",
  "ncm": "85177010",
  "origem_fiscal": "0",
  "cfop_padrao": "5102",
  "requires_invoice": true,
  "variants": [
    {
      "nome": "Azul",
      "codigo": "AZ-01",
      "atributo": "Cor",
      "cor": "#0000FF"
    }
  ]
}
 e o retorno eh esse 
[
  {
    "product_sk": 100,
    "product_id": "PRD-001",
    "company_id": "uuid-company",
    "nome": "Impressora 3D",
    "descricao": "Impressora industrial",
    "tipo": "hardware",
    "ncm": "84433210",
    "origem_fiscal": "0",
    "cfop_padrao": "5102",
    "requires_invoice": true,
    "effective_date": "2026-04-30T01:06:57.782Z",
    "end_date": "2026-04-30T01:06:57.782Z",
    "is_current": true,
    "created_at": "2026-04-30T01:06:57.782Z"
  }
]
isso significa que eu tenho que extender em model o dto? ou eu tenho que ter duas entidades? uma que vem do servidor e uma que eu controlo no app? pq se em clean eu tenhi que respeitas os dominios entao usecase tem que pegar o dto converter pra entidade passar esssa entidade do dto para repo que converte pra model, vai pro source, retorna outro model, vai pro repo converte pra entidade e vai pro usecase como resposta 