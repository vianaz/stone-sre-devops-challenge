import { UserFactory } from '#database/factories/user_factory'
import testUtils from '@adonisjs/core/services/test_utils'
import { test } from '@japa/runner'
import path from 'path'

test.group('Users', (group) => {
  group.each.setup(() => testUtils.db().withGlobalTransaction())

  const endpoint = '/users'
  test('should return all users', async ({ client }) => {
    const user = UserFactory.create()
    const response = await client.get(endpoint)

    response.assertStatus(200)
    response.assertBodyContains(user)
  })

  test('should create a user', async ({ client }) => {
    const data = {
      name: 'John',
      cpf: '12345678910',
      email: 'teste@gmail.com',
      lastName: 'Doe',
      birthdate: '1990-01-01'
    }
    const response = await client.post(endpoint).json(data)

    response.assertStatus(201)
    // TODO: arrumar esse assert
    // response.assertBodyContains(data)
  })

  test('should not create a user with a invalid cpf', async ({ client }) => {
    const response = await client.post(endpoint).json({
      name: 'John Doe',
      cpf: '1234567891',
      email: 'teste@gmail.com',
      birthdate: '1990-01-01'
    })

    response.assertStatus(422)
  })

  test('should not create a user with a missing value', async ({ client }) => {
    const response = await client.post(endpoint).json({
      name: 'John Doe',
      email: 'teste@gmail.com',
      cpf: '12345678910',
    })

    response.assertStatus(422)
  })


  test('should return a user by cpf', async ({ client }) => {
    const user = await UserFactory.create()
    const response = await client.get(path.join(endpoint, user.cpf))

    response.assertStatus(200)
  })
})

