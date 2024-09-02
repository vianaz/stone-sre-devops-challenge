import { test } from '@japa/runner'

test.group('Users', () => {
  const endpoint = '/users'
  test('should return all users', async ({ client }) => {
    const response = await client.get(endpoint)

    response.assertStatus(200)
  })

  test('should create a user', async ({ client }) => {
    const response = await client.post(endpoint).json({
      name: 'John Doe',
      cpf: '123.456.789-10',
      email: 'teste@gmail.com',
      birthdate: '1990-01-01'
    })

    response.assertStatus(201)
  })

  test('should not create a user with a invlid cpf', async ({ client }) => {
    const response = await client.post(endpoint).json({
      name: 'John Doe',
      cpf: '123.456.789-1',
      email: 'teste@gmail.com',
      birthdate: '1990-01-01'
    })

    response.assertStatus(422)
  })

  test('should not create a user with a missing value', async ({ client }) => {
    const response = await client.post(endpoint).json({
      name: 'John Doe',
      email: 'teste@gmail.com',
      cpf: '123.456.789-10',
    })


    response.assertStatus(422)
  })


  test('should return a user by cpf', async ({ client }) => {
    const response = await client.get(`${endpoint}/123.456.789-10`)

    response.assertStatus(200)
  })
})

