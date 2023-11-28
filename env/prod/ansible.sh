#!/bin/bash
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible
tee -a playbook.yml > /dev/null <<EOT

- hosts: prod-instance
  tasks:
  - name: instalando python3 e virtualenv
    apt:      #sinaliza instalação de pacotes
      pkg: #pacotes a serem inseridos
      - python3
      - virtualenv
      update_cache: yes #atualiza os repositórios antes de fazer a instalação de novos pacotes
    become: yes #permite a execução dos comandos do playbook como usuário root
  - name: git clone
    ansible.builtin.git:
      repo: https://github.com/alura-cursos/clientes-leo-api.git
      dest: /home/ubuntu/projects/
      version: master
      force: yes #força a pegar sempre a versão mais nova
  - name: instalando dependências com pip (Django e Django Rest)
    pip:
      virtualenv: /home/ubuntu/projects/venv #aqui o ansible será responsável por criar e iniciar a virtual env
      requirements: /home/ubuntu/projects/requirements.txt
  - name: alterando o host do settings
    lineinfile: #essa propriedade indica que uma linha será alterada em um arquivo
      path: /home/ubuntu/projects/setup/settings.py
      regexp:  'ALLOWED_HOSTS' #linha a ser alterada
      line: 'ALLOWED_HOSTS = ["*"]' #novo conteúdo da linha
      backrefs: yes #não alterar o arquivo caso a linha não exista
  - name: configurando banco de dados
    shell: '. /home/ubuntu/projects/venv/bin/activate; python /home/ubuntu/projects/manage.py migrate'
  - name: carregando dados iniciais
    shell: '. /home/ubuntu/projects/venv/bin/activate; python /home/ubuntu/projects/manage.py loaddata clientes.json'
  - name: iniciando o servidor
    shell: '. /home/ubuntu/projects/venv/bin/activate; nohup python /home/ubuntu/projects/manage.py runserver 0.0.0.0:8000 &'
EOT 
ansible-plabook playbook.yml