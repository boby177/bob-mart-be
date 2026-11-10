export const FIND_ALL_PRODUCTS = `
  MATCH (p:Product)
  RETURN p { .*, createdAt: toString(p.createdAt) } AS product
  ORDER BY p.createdAt DESC
`;

export const FIND_PRODUCT_BY_ID = `
  MATCH (p:Product { id: $id })
    RETURN p { .*, createdAt: toString(p.createdAt) } AS product
`;
