import random
import uuid
import datetime
from faker import Faker

# Setup Faker with Brazilian locale
fake = Faker('pt_BR')

# Constants for Enums
CUSTOMER_STATUS = ['lead', 'aluno', 'cliente_klibra', 'inativo']
TRANSACTION_TYPE = ['entrada', 'saida']
PARTICIPATION_TYPE = ['aluno', 'acompanhante']
PRODUCT_TYPE = ['hardware', 'consumivel']
SALE_STATUS = ['pendente', 'parcial', 'paga', 'cancelada', 'concluida']
PAYMENT_STATUS = ['pendente', 'pago', 'vencido', 'cancelado']
ITEM_STATUS = ['em_estoque', 'reservado', 'embalando', 'enviado', 'entregue', 'vendido', 'manutencao']
SHIPPING_STATUS = ['pendente', 'embalando', 'enviado', 'entregue', 'cancelado']
SHIPPING_CARRIER = ['correios', 'jadlog', 'melhorenvio', 'retirada_local']

# Pre-defined IDs from schema SEED
COMPANY_INSTITUTO = 'cf2cbf59-7d43-4a9f-8f38-2e616ec140de'
COMPANY_KLIBRA = '385e04c1-439b-44a9-a350-a8928a44431c'
COMPANIES = [COMPANY_INSTITUTO, COMPANY_KLIBRA]

def generate_insert(table, data):
    columns = ", ".join(data.keys())
    values = ", ".join([f"'{v}'" if isinstance(v, str) else str(v).lower() if isinstance(v, bool) else "NULL" if v is None else str(v) for v in data.values()])
    return f"INSERT INTO public.{table} ({columns}) VALUES ({values});"

def main():
    output_file = "seed_data_population.sql"
    with open(output_file, "w", encoding="utf-8") as f:
        f.write("BEGIN;\n\n")

        # 1. Customers (50)
        customer_ids = []
        f.write("-- 1. CUSTOMERS\n")
        for _ in range(50):
            c_id = str(uuid.uuid4())
            customer_ids.append(c_id)
            data = {
                "id": c_id,
                "nome_completo": fake.name(),
                "cpf": fake.cpf(),
                "data_nascimento": fake.date_of_birth(minimum_age=20, maximum_age=65).isoformat(),
                "telefone": fake.phone_number(),
                "email": fake.email(),
                "instagram": f"@{fake.user_name()}",
                "endereco_completo": fake.address().replace("\n", ", "),
                "origem": random.choice(["Instagram", "Indicação", "Congresso", "WhatsApp"]),
                "status": random.choice(CUSTOMER_STATUS),
                "is_active": True
            }
            f.write(generate_insert("customers", data) + "\n")
        f.write("\n")

        # 2. Courses (5)
        course_ids = []
        course_names = [
            "Imersão em Odontologia Digital 3D",
            "Masterclass em Prótese sobre Implante",
            "Workflow Digital na Ortodontia",
            "Escaneamento Intraoral e Planejamento",
            "Treinamento de Equipe: Fluxo K-Libra"
        ]
        f.write("-- 2. COURSES\n")
        for name in course_names:
            co_id = str(uuid.uuid4())
            course_ids.append(co_id)
            data = {
                "id": co_id,
                "nome": name,
                "descricao": f"Curso avançado de {name} com foco teórico e prático.",
                "permite_px3": random.choice([True, False]),
                "is_active": True
            }
            f.write(generate_insert("courses", data) + "\n")
        f.write("\n")

        # 3. Products (10)
        product_ids = []
        hardware_names = ["Scanner Intraoral KL-1", "Impressora 3D Orion", "Forno de Sinterização", "Monitor 4K Lab"]
        consumable_names = ["Resina Model 1kg", "Pó para Scanner 50g", "Álcool Isopropílico 5L", "Luvas Nitrílicas CX"]
        f.write("-- 3. PRODUCTS\n")
        for i in range(10):
            p_id = str(uuid.uuid4())
            product_ids.append(p_id)
            tipo = random.choice(PRODUCT_TYPE)
            nome = random.choice(hardware_names) if tipo == 'hardware' else random.choice(consumable_names)
            data = {
                "id": p_id,
                "nome": nome,
                "descricao": f"Produto de alta qualidade para odontologia digital.",
                "tipo": tipo,
                "sku": f"SKU-{random.randint(1000, 9999)}-{i}",
                "is_active": True
            }
            f.write(generate_insert("products", data) + "\n")
        f.write("\n")

        # 4. Inventory Balances
        f.write("-- 4. INVENTORY BALANCES\n")
        for p_id in product_ids:
            data = {
                "product_id": p_id,
                "quantidade_atual": random.randint(5, 100)
            }
            f.write(generate_insert("inventory_balances", data) + "\n")
        f.write("\n")

        # 5. Sales (30)
        sale_ids = []
        f.write("-- 5. SALES\n")
        for _ in range(30):
            s_id = str(uuid.uuid4())
            sale_ids.append(s_id)
            subtotal = random.randint(100, 5000)
            desconto = random.randint(0, int(subtotal * 0.1))
            valor_total = subtotal - desconto
            status = random.choice(SALE_STATUS)
            valor_pago = valor_total if status == 'paga' or status == 'concluida' else random.randint(0, int(valor_total)) if status == 'parcial' else 0
            
            data = {
                "id": s_id,
                "request_id": str(uuid.uuid4()),
                "company_id": random.choice(COMPANIES),
                "customer_id": random.choice(customer_ids),
                "sale_type": random.choice(["hardware", "course", "service"]),
                "status": status,
                "subtotal": subtotal,
                "desconto": desconto,
                "valor_total": valor_total,
                "valor_pago": valor_pago,
                "created_at": fake.date_between(start_date='-60d', end_date='now').isoformat()
            }
            f.write(generate_insert("sales", data) + "\n")
        f.write("\n")

        # 6. Sale Items
        f.write("-- 6. SALE ITEMS\n")
        for s_id in sale_ids:
            # Each sale has 1-3 items
            for _ in range(random.randint(1, 3)):
                is_product = random.choice([True, False])
                p_item_id = random.choice(product_ids) if is_product else None
                c_item_id = random.choice(course_ids) if not is_product else None
                
                v_unit = random.randint(50, 2000)
                qty = random.randint(1, 5)
                
                data = {
                    "id": str(uuid.uuid4()),
                    "sale_id": s_id,
                    "product_id": p_item_id if p_item_id else "NULL",
                    "course_id": c_item_id if c_item_id else "NULL",
                    "item_type": "product" if is_product else "course",
                    "descricao": "Item da venda",
                    "quantidade": qty,
                    "valor_unitario": v_unit,
                    "valor_total": v_unit * qty
                }
                # Fix NULL values for the generator
                line = generate_insert("sale_items", data).replace("'NULL'", "NULL")
                f.write(line + "\n")
        f.write("\n")

        # 7. Payments
        f.write("-- 7. PAYMENTS\n")
        for s_id in sale_ids:
            data = {
                "id": str(uuid.uuid4()),
                "sale_id": s_id,
                "customer_id": random.choice(customer_ids), # Simplified for sample
                "forma_pagamento": random.choice(["Cartão de Crédito", "Pix", "Boleto", "Dinheiro"]),
                "parcela_numero": 1,
                "total_parcelas": 1,
                "valor": random.randint(100, 5000),
                "data_vencimento": fake.date_this_year().isoformat(),
                "status": random.choice(PAYMENT_STATUS)
            }
            f.write(generate_insert("payments", data) + "\n")
        f.write("\n")

        f.write("COMMIT;\n")

    print(f"File {output_file} generated with random data successfully!")

if __name__ == "__main__":
    main()
