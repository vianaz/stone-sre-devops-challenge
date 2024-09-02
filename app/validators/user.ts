import vine from '@vinejs/vine'

export const createUserValidator = vine.compile(
  vine.object({
    name: vine.string(),
    cpf: vine.string().regex(/^\d{3}\.\d{3}\.\d{3}-\d{2}$/),
    email: vine.string().email(),
    birthdate: vine.date(),
  })
)
