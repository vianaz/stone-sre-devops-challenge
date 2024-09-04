import { UserFactory } from '#database/factories/user_factory'
import UsersRepository from '#repositories/user_repository'
import UsersService from '#services/user_service'
import { test } from '@japa/runner'
import sinon from 'sinon'

test.group('UsersService.getUsers', () => {
  const usersRepositoryMock = sinon.createStubInstance(UsersRepository)
  const sut = new UsersService(usersRepositoryMock)

  test('should return all users correctly', async ({ assert }) => {
    const users = await UserFactory.makeMany(2)
    usersRepositoryMock.findAll.resolves(users)

    const result = await sut.getUsers()

    assert.equal(result, users)
    sinon.assert.calledOnce(usersRepositoryMock.findAll)
  })
})

test.group('UsersService.getUserByCpf', () => {
  const usersRepositoryMock = sinon.createStubInstance(UsersRepository)
  const sut = new UsersService(usersRepositoryMock)

  test('should return user by cpf correctly', async ({ assert }) => {
    const user = await UserFactory.make()
    usersRepositoryMock.findByCpf.resolves(user)

    const result = await sut.getUserByCpf('12345678910')

    assert.equal(result, user)
    sinon.assert.calledOnce(usersRepositoryMock.findByCpf)
  })
})

test.group('UsersService.createUser', () => {
  const usersRepositoryMock = sinon.createStubInstance(UsersRepository)
  const sut = new UsersService(usersRepositoryMock)

  test('should create user correctly', async ({ assert }) => {
    const user = await UserFactory.make()
    usersRepositoryMock.createUser.resolves(user)

    const result = await sut.createUser({
      name: 'John Doe',
      cpf: '12345678910',
      email: 'teste@gmail.com',
      birthdate: new Date('1990-01-01')
    })

    assert.equal(result, user)
    sinon.assert.calledOnce(usersRepositoryMock.createUser)
  })
})
