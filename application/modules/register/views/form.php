<?php echo form_open('register/submit'); ?>
  <div class="form-group">
    <label>Jméno / název účtu</label>
    <input type="text" name="name" class="form-control" placeholder="Jan Novák / Moje firma">
  </div>
  <div class="form-group">
    <label>E-mail</label>
    <input type="email" name="email" class="form-control" required>
  </div>
  <div class="form-group">
    <label>Heslo</label>
    <input type="password" name="password" class="form-control" required minlength="8">
  </div>
  <button type="submit" class="btn btn-primary">Zaregistrovat</button>
<?php echo form_close(); ?>
