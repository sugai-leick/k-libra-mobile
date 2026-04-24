BEGIN;

-- =================================================================================
-- 1. EXTENSÕES
-- =================================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- =================================================================================
-- 2. ENUMS
-- =================================================================================

DO $$ BEGIN
    CREATE TYPE customer_status AS ENUM (
        'lead',
        'aluno',
        'cliente_klibra',
        'inativo'
    );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE transaction_type AS ENUM (
        'entrada',
        'saida'
    );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE participation_type AS ENUM (
        'aluno',
        'acompanhante'
    );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE product_type AS ENUM (
        'hardware',
        'consumivel'
    );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE sale_status AS ENUM (
        'pendente',
        'parcial',
        'paga',
        'cancelada',
        'concluida'
    );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE payment_status AS ENUM (
        'pendente',
        'pago',
        'vencido',
        'cancelado'
    );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE item_status AS ENUM (
        'em_estoque',
        'reservado',
        'embalando',
        'enviado',
        'entregue',
        'vendido',
        'manutencao'
    );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE shipping_status AS ENUM (
        'pendente',
        'embalando',
        'enviado',
        'entregue',
        'cancelado'
    );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE shipping_carrier AS ENUM (
        'correios',
        'jadlog',
        'melhorenvio',
        'retirada_local'
    );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- =================================================================================
-- 3. BASE TABLE
-- =================================================================================
-- Só como padrão mental; em Postgres não usamos herança aqui.
-- Cada tabela importante terá:
-- created_at, updated_at, deleted_at

-- =================================================================================
-- 4. COMPANIES
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_companies_deleted_at ON public.companies(deleted_at);
CREATE INDEX IF NOT EXISTS idx_companies_updated_at ON public.companies(updated_at);

-- =================================================================================
-- 5. CUSTOMERS
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    nome_completo VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    data_nascimento DATE,
    telefone VARCHAR(20),
    email VARCHAR(255),
    instagram VARCHAR(255),
    endereco_completo TEXT,
    origem VARCHAR(100),

    status customer_status NOT NULL DEFAULT 'lead',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_customers_status ON public.customers(status);
CREATE INDEX IF NOT EXISTS idx_customers_is_active ON public.customers(is_active);
CREATE INDEX IF NOT EXISTS idx_customers_updated_at ON public.customers(updated_at);
CREATE INDEX IF NOT EXISTS idx_customers_deleted_at ON public.customers(deleted_at);

-- =================================================================================
-- 6. COURSES
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.courses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    permite_px3 BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_courses_is_active ON public.courses(is_active);
CREATE INDEX IF NOT EXISTS idx_courses_updated_at ON public.courses(updated_at);
CREATE INDEX IF NOT EXISTS idx_courses_deleted_at ON public.courses(deleted_at);

-- =================================================================================
-- 7. PRODUCTS
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    tipo product_type NOT NULL,
    sku VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_products_sku_unique
ON public.products(sku)
WHERE sku IS NOT NULL AND deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_products_tipo ON public.products(tipo);
CREATE INDEX IF NOT EXISTS idx_products_updated_at ON public.products(updated_at);
CREATE INDEX IF NOT EXISTS idx_products_deleted_at ON public.products(deleted_at);

-- =================================================================================
-- 8. SALES
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.sales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    request_id UUID UNIQUE NOT NULL,
    company_id UUID REFERENCES public.companies(id) ON DELETE RESTRICT,
    customer_id UUID REFERENCES public.customers(id) ON DELETE RESTRICT,

    sale_type VARCHAR(50) NOT NULL, -- 'hardware', 'course', etc.
    status sale_status NOT NULL DEFAULT 'pendente',

    subtotal NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (subtotal >= 0),
    desconto NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (desconto >= 0),
    valor_total NUMERIC(10,2) NOT NULL CHECK (valor_total >= 0),
    valor_pago NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (valor_pago >= 0),

    observacoes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_sales_company_id ON public.sales(company_id);
CREATE INDEX IF NOT EXISTS idx_sales_customer_id ON public.sales(customer_id);
CREATE INDEX IF NOT EXISTS idx_sales_status ON public.sales(status);
CREATE INDEX IF NOT EXISTS idx_sales_updated_at ON public.sales(updated_at);
CREATE INDEX IF NOT EXISTS idx_sales_deleted_at ON public.sales(deleted_at);

-- =================================================================================
-- 9. SALE ITEMS
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.sale_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    sale_id UUID NOT NULL REFERENCES public.sales(id) ON DELETE CASCADE,
    product_id UUID REFERENCES public.products(id) ON DELETE RESTRICT,
    course_id UUID REFERENCES public.courses(id) ON DELETE RESTRICT,

    item_type VARCHAR(50) NOT NULL, -- 'product' | 'course'
    descricao VARCHAR(255) NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    valor_unitario NUMERIC(10,2) NOT NULL CHECK (valor_unitario >= 0),
    valor_total NUMERIC(10,2) NOT NULL CHECK (valor_total >= 0),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT chk_sale_items_target CHECK (
        (product_id IS NOT NULL AND course_id IS NULL)
        OR
        (product_id IS NULL AND course_id IS NOT NULL)
    )
);

CREATE INDEX IF NOT EXISTS idx_sale_items_sale_id ON public.sale_items(sale_id);
CREATE INDEX IF NOT EXISTS idx_sale_items_product_id ON public.sale_items(product_id);
CREATE INDEX IF NOT EXISTS idx_sale_items_course_id ON public.sale_items(course_id);
CREATE INDEX IF NOT EXISTS idx_sale_items_updated_at ON public.sale_items(updated_at);
CREATE INDEX IF NOT EXISTS idx_sale_items_deleted_at ON public.sale_items(deleted_at);

-- =================================================================================
-- 10. PAYMENTS
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    sale_id UUID NOT NULL REFERENCES public.sales(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE RESTRICT,

    forma_pagamento VARCHAR(100) NOT NULL,
    parcela_numero INTEGER,
    total_parcelas INTEGER,

    valor NUMERIC(10,2) NOT NULL CHECK (valor >= 0),
    data_vencimento DATE NOT NULL,
    data_pagamento TIMESTAMPTZ,
    status payment_status NOT NULL DEFAULT 'pendente',

    observacoes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_payments_sale_id ON public.payments(sale_id);
CREATE INDEX IF NOT EXISTS idx_payments_customer_id ON public.payments(customer_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON public.payments(status);
CREATE INDEX IF NOT EXISTS idx_payments_data_vencimento ON public.payments(data_vencimento);
CREATE INDEX IF NOT EXISTS idx_payments_updated_at ON public.payments(updated_at);
CREATE INDEX IF NOT EXISTS idx_payments_deleted_at ON public.payments(deleted_at);

-- =================================================================================
-- 11. FINANCIAL TRANSACTIONS
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.financial_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID REFERENCES public.companies(id) ON DELETE RESTRICT,
    tipo transaction_type NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    valor NUMERIC(10,2) NOT NULL CHECK (valor > 0),

    reference_id UUID,
    reference_type VARCHAR(50),

    observacoes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_financial_transactions_company_id ON public.financial_transactions(company_id);
CREATE INDEX IF NOT EXISTS idx_financial_transactions_tipo ON public.financial_transactions(tipo);
CREATE INDEX IF NOT EXISTS idx_financial_transactions_updated_at ON public.financial_transactions(updated_at);
CREATE INDEX IF NOT EXISTS idx_financial_transactions_deleted_at ON public.financial_transactions(deleted_at);

-- =================================================================================
-- 12. CUSTOMER COURSES
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.customer_courses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    customer_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
    course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE RESTRICT,

    tipo_participacao participation_type NOT NULL DEFAULT 'aluno',
    status VARCHAR(50) NOT NULL,
    data_inicio DATE,
    data_conclusao DATE,

    certificado BOOLEAN NOT NULL DEFAULT FALSE,
    almoco BOOLEAN NOT NULL DEFAULT FALSE,
    feedback BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_customer_courses_unique_active
ON public.customer_courses(customer_id, course_id)
WHERE deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_customer_courses_customer_id ON public.customer_courses(customer_id);
CREATE INDEX IF NOT EXISTS idx_customer_courses_course_id ON public.customer_courses(course_id);
CREATE INDEX IF NOT EXISTS idx_customer_courses_updated_at ON public.customer_courses(updated_at);
CREATE INDEX IF NOT EXISTS idx_customer_courses_deleted_at ON public.customer_courses(deleted_at);

-- =================================================================================
-- 13. INVENTORY BALANCES
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.inventory_balances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    product_id UUID NOT NULL UNIQUE REFERENCES public.products(id) ON DELETE CASCADE,
    quantidade_atual INTEGER NOT NULL DEFAULT 0 CHECK (quantidade_atual >= 0),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_inventory_balances_product_id ON public.inventory_balances(product_id);
CREATE INDEX IF NOT EXISTS idx_inventory_balances_updated_at ON public.inventory_balances(updated_at);
CREATE INDEX IF NOT EXISTS idx_inventory_balances_deleted_at ON public.inventory_balances(deleted_at);

-- =================================================================================
-- 14. INVENTORY ITEMS
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.inventory_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,
    serial_number VARCHAR(100) UNIQUE NOT NULL,
    sale_id UUID REFERENCES public.sales(id) ON DELETE SET NULL,
    company_id UUID REFERENCES public.companies(id) ON DELETE RESTRICT,

    status item_status NOT NULL DEFAULT 'em_estoque',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_inventory_items_product_id ON public.inventory_items(product_id);
CREATE INDEX IF NOT EXISTS idx_inventory_items_sale_id ON public.inventory_items(sale_id);
CREATE INDEX IF NOT EXISTS idx_inventory_items_company_id ON public.inventory_items(company_id);
CREATE INDEX IF NOT EXISTS idx_inventory_items_status ON public.inventory_items(status);
CREATE INDEX IF NOT EXISTS idx_inventory_items_updated_at ON public.inventory_items(updated_at);
CREATE INDEX IF NOT EXISTS idx_inventory_items_deleted_at ON public.inventory_items(deleted_at);

-- =================================================================================
-- 15. INVENTORY TRANSACTIONS
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.inventory_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    tipo transaction_type NOT NULL,

    reference_type VARCHAR(50) NOT NULL,
    reference_id UUID,

    observacoes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_inventory_transactions_product_id ON public.inventory_transactions(product_id);
CREATE INDEX IF NOT EXISTS idx_inventory_transactions_updated_at ON public.inventory_transactions(updated_at);
CREATE INDEX IF NOT EXISTS idx_inventory_transactions_deleted_at ON public.inventory_transactions(deleted_at);

-- =================================================================================
-- 16. INVENTORY ITEM HISTORY
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.inventory_item_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    item_id UUID NOT NULL REFERENCES public.inventory_items(id) ON DELETE CASCADE,
    status_anterior item_status,
    status_novo item_status NOT NULL,

    reference_type VARCHAR(50) NOT NULL,
    reference_id UUID,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_inventory_item_history_item_id ON public.inventory_item_history(item_id);
CREATE INDEX IF NOT EXISTS idx_inventory_item_history_updated_at ON public.inventory_item_history(updated_at);
CREATE INDEX IF NOT EXISTS idx_inventory_item_history_deleted_at ON public.inventory_item_history(deleted_at);

-- =================================================================================
-- 17. SHIPPING
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.shipping (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    sale_id UUID NOT NULL REFERENCES public.sales(id) ON DELETE CASCADE,

    status shipping_status NOT NULL DEFAULT 'pendente',
    carrier shipping_carrier,
    tracking_code VARCHAR(100),
    tracking_url TEXT,
    last_tracking_status VARCHAR(255),
    last_tracking_update TIMESTAMPTZ,
    shipped_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_shipping_sale_id ON public.shipping(sale_id);
CREATE INDEX IF NOT EXISTS idx_shipping_status ON public.shipping(status);
CREATE INDEX IF NOT EXISTS idx_shipping_updated_at ON public.shipping(updated_at);
CREATE INDEX IF NOT EXISTS idx_shipping_deleted_at ON public.shipping(deleted_at);

-- =================================================================================
-- 18. SHIPPING ITEMS
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.shipping_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    shipping_id UUID NOT NULL REFERENCES public.shipping(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,
    inventory_item_id UUID REFERENCES public.inventory_items(id) ON DELETE SET NULL,

    quantidade INTEGER NOT NULL CHECK (quantidade > 0),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_shipping_items_shipping_id ON public.shipping_items(shipping_id);
CREATE INDEX IF NOT EXISTS idx_shipping_items_product_id ON public.shipping_items(product_id);
CREATE INDEX IF NOT EXISTS idx_shipping_items_inventory_item_id ON public.shipping_items(inventory_item_id);
CREATE INDEX IF NOT EXISTS idx_shipping_items_updated_at ON public.shipping_items(updated_at);
CREATE INDEX IF NOT EXISTS idx_shipping_items_deleted_at ON public.shipping_items(deleted_at);

-- =================================================================================
-- 19. SHIPPING EVENTS
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.shipping_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    shipping_id UUID NOT NULL REFERENCES public.shipping(id) ON DELETE CASCADE,
    status VARCHAR(100) NOT NULL,
    description TEXT,
    location VARCHAR(255),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_shipping_events_shipping_id ON public.shipping_events(shipping_id);
CREATE INDEX IF NOT EXISTS idx_shipping_events_updated_at ON public.shipping_events(updated_at);
CREATE INDEX IF NOT EXISTS idx_shipping_events_deleted_at ON public.shipping_events(deleted_at);

-- =================================================================================
-- 20. AUDIT LOGS
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    entity_name VARCHAR(100) NOT NULL,
    entity_id UUID NOT NULL,
    action VARCHAR(50) NOT NULL,
    performed_by VARCHAR(255) DEFAULT 'system',
    origin VARCHAR(50) DEFAULT 'system',
    metadata JSONB,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_audit_logs_entity_name_entity_id ON public.audit_logs(entity_name, entity_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_updated_at ON public.audit_logs(updated_at);
CREATE INDEX IF NOT EXISTS idx_audit_logs_deleted_at ON public.audit_logs(deleted_at);

-- =================================================================================
-- 21. SEED
-- =================================================================================

INSERT INTO public.companies (id, nome)
VALUES
    ('cf2cbf59-7d43-4a9f-8f38-2e616ec140de', 'Instituto'),
    ('385e04c1-439b-44a9-a350-a8928a44431c', 'K-Libra')
ON CONFLICT (id) DO NOTHING;

COMMIT;