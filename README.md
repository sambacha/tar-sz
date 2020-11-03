

Generate a plain-text, encrypted archive that is secured using the public key of a particular GitHub user.

## ssh-tgz

### Archive and Secure

Usage is _similar_ to `tar`.

```bash
ssh-tgzx github-username archive-file [files | directories]
```

### Extract

Send the file to user who owns the identity and they simply:

```bash
bash ./archive-file identity-file
```

### List

```bash
bash ./archive-file identity-file t
```

### Example

#### Create secure archive

To archive some files to send to me:

```bash
ssh-tgzx $GITHUB_USERNAME private.tgzx private-folder secret-file
```

It is (relatively) safe to send the file to me via insecure channels.

### Extract

I can extract is using:

```bash
bash ./private.tgzx ~/.ssh/id_rsa
```

### List

Or just list the contents:

bash ./private.tgzx ~/.ssh/id_rsa t

## tgzx

## Archive and Secure

Usage is _similar_ to `tar`.

```bash
tgzx archive-file [files | directories]
```

## Extract

```bash
./archive-file
```

### Example

#### Create secure archive

```bash
tgzx ssh.tgzx .ssh
```

#### Extract

```bash
./ssh.tgzx
```

#### List

```bash
./ssh.tgzx t
```

## License 

SPDX-License-Identifier: ISC
