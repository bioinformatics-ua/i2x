cd /i2x && rake db:create 
cd /i2x && rake db:migrate

cd /i2x && rails s &
cd /i2x && rake jobs:work
